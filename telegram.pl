#!/usr/bin/perl

# Envio de gráfico por email através do ZABBIX (Send zabbix alerts graph mail)
#
# 
# Copyright (C) <2016>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Contacts:
# Eracydes Carvalho (Sansão Simonton) - NOC Analyst - sansaoipb@gmail.com
# Thiago Paz - NOC Analyst - thiagopaz1986@gmail.com

use strict;
use warnings;
use HTTP::Cookies;
use WWW::Mechanize; 
use JSON::RPC::Client;
use Encode;
use POSIX;

## Dados do Zabbix ##############################################################################################################
my $server_ip	= 'http://127.0.0.1/zabbix'; # URL de acesso ao FRONT com "http://"                                             #
my $usuario	= 'Admin';                                                                                                      #
my $senha     	= 'zabbix';                                                                                                     #
my $script    	= '/etc/zabbix/scripts/telegram';                                                                               #
my $client 	= new JSON::RPC::Client;                                                                                        #
#################################################################################################################################

## Configuracao do Grafico ######################################################################################################
my $color  	= '00C800'; # Cor do grafico em Hex. (sem tralha)                                                               #
my $periodo 	= 3600; # 1 hora em segundos                                                                                    #
my $height  	= 200;  # Altura                                                                                                #
my $width  	= 900;  # Largura                                                                                               #
my $stime   	= strftime("%Y%m%d%H%M%S", localtime( time-3600 )); # Hora inicial do grafico [time-3600 = 1 hora atras]        #
#################################################################################################################################

## Separando argumentos #########################################################################################################
my ($itemname, $itemid, $corpo) = split /\#/, $ARGV[2], 3;                                                                      #
#################################################################################################################################

#################################################################################################################################
my $graph = "/tmp/$itemid.png";                                                                                                 #
                                                                                                                                #
my $mech = WWW::Mechanize->new();                                                                                               #
$mech->cookie_jar(HTTP::Cookies->new());                                                                                        #
$mech->get("$server_ip/index.php?login=1");                                                                                     #
$mech->field(name => $usuario);                                                                                                 #
$mech->field(password => $senha);                                                                                               #
$mech->click();                                                                                                                 #
                                                                                                                                #
my $png = $mech->get("$server_ip/chart3.php?name=$itemname&period=$periodo&width=$width&height=$height&stime=$stime&items[0][itemid]=$itemid&items[0][drawtype]=5&items[0][color]=$color");
                                                                                                                                #
open my $image, '>', $graph or die $!;                                                                                          #
$image->print($png->decoded_content);                                                                                           #
$image->close;                                                                                                                  #
#################################################################################################################################
utf8::decode($ARGV[1]);
utf8::decode($corpo);

chdir($script) || die "Não foi possivel localizar o diretório do telegram-cli:$!";
if (&tipo == 0 || &tipo == 3) {
				`./telegram-cli -k tg-server.pub -c telegram.config -WR -U zabbix -e "send_photo $ARGV[0] $graph $ARGV[1] $corpo"` || die "Não foi possivel executar o telegram-cli:$!";
}
else {
	`./telegram-cli -k tg-server.pub -c telegram.config -WR -U zabbix -e "msg $ARGV[0] $ARGV[1] $corpo"` || die "Não foi possivel executar o telegram-cli:$!";
}

unlink ("$graph");

sub tipo
{
	my $json = {
			jsonrpc => '2.0',
			method  => 'user.login',
			params  => {
					user  => $usuario,
					password => $senha
			},
			id => 1
	};

	my $response = $client->call("$server_ip/api_jsonrpc.php", $json);
	my $authID = $response->content->{'result'};
	$itemid =~ s/^\s+//;

	$json =  {
			jsonrpc => '2.0',
			method  => 'item.get',
			params  => {
					output => ['value_type'],
					itemids => $itemid
			},
			auth => $authID,
			id => 2
	};
	
	$response = $client->call("$server_ip/api_jsonrpc.php", $json);

	my $itemtype; 
	foreach my $get_itemtype (@{$response->content->{result}}) {
		$itemtype = $get_itemtype->{value_type}
	}
	$json = {
			jsonrpc => '2.0',
			method => 'user.logout',
			params => [],
			id => 3,
			auth => $authID
	};
	$client->call("$server_ip/api_jsonrpc.php", $json);
	return $itemtype;
}

exit;
