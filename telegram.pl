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
use Data::Dumper;
use Encode;
use POSIX;

## Dados do Zabbix ##############################################################################################################
my $server_ip  = 'http://127.0.0.1/zabbix'; # URL de acesso ao FRONT com "http://"
my $user       = 'Admin';
my $password   = 'zabbix';
my $script     = '/etc/zabbix/scripts/telegram';
my $client     = new JSON::RPC::Client;
my ($json, $response, $authID);
#################################################################################################################################

## Configuracao do Grafico ######################################################################################################
#my $color   = '00C800'; # Cor do grafico em Hex. (sem tralha)
my $height  = 200;  # Altura
my $width   = 900;  # Largura
my $stime   = strftime("%Y%m%d%H%M%S", localtime( time-3600 )); # Hora inicial do grafico [time-3600 = 1 hora atras]
#################################################################################################################################

## Separando argumentos #########################################################################################################
my ($itemname, $eventid, $itemid, $color, $period, $body) = split /\#/, $ARGV[2], 6;
#################################################################################################################################
$body =~ s/\n//g;
$body =~ s/\\n\s+/\\n/g;
$eventid =~ s/^\s+//;
#################################################################################################################################
my $graph = "/tmp/$itemid.png";

my $mech = WWW::Mechanize->new();
$mech->cookie_jar(HTTP::Cookies->new());
$mech->get("$server_ip/index.php?login=1");
$mech->field(name => $user);
$mech->field(password => $password);
$mech->click();

my $png = $mech->get("$server_ip/chart3.php?name=$itemname&period=$period&width=$width&height=$height&stime=$stime&items[0][itemid]=$itemid&items[0][drawtype]=5&items[0][color]=$color");

open my $image, '>', $graph or die $!;
$image->print($png->decoded_content);
$image->close;
#################################################################################################################################
utf8::decode($ARGV[1]);
utf8::decode($body);

my $valor;
chdir($script) || die "Não foi possivel localizar o diretório do telegram-cli:$!";
if (&tipo == 0 || &tipo == 3) {
	$valor = `./telegram-cli -k tg-server.pub -c telegram.config -WR -U zabbix -e 'send_photo $ARGV[0] $graph "$ARGV[1] $body"'` || die "Não foi possivel executar o telegram-cli:$!";
        unless (grep (m/FAIL/, $valor)) {
		&ack; 
		&logout;
	}
}
else {
        $valor = `./telegram-cli -k tg-server.pub -c telegram.config -WR -U zabbix -e 'msg $ARGV[0] "$ARGV[1] $body"'` || die "Não foi possivel executar o telegram-cli:$!";
        unless (grep (m/FAIL/, $valor)) {
		&ack; 
		&logout;
	}
}

unlink ("$graph");

sub tipo {
	$json = {
		jsonrpc => '2.0',
		method  => 'user.login',
		params  => {
			user  => $user  ,
			password => $password
     		},
   		id => 1
  	};

	$response = $client->call("$server_ip/api_jsonrpc.php", $json);
	#print Dumper ($response);
	
	$authID = $response->content->{'result'};
	$itemid =~ s/^\s+//;

	$json = {
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
	#print Dumper ($response);
	
	my $itemtype; 
	foreach my $get_itemtype (@{$response->content->{result}}) {	
		$itemtype = $get_itemtype->{value_type}
	}
	return $itemtype;
}

sub ack {
	$json = {
		jsonrpc => '2.0',
		method  => 'event.acknowledge',
		params  => {
			eventids  => $eventid,
			message => "Telegram enviado com sucesso para $ARGV[0]"
		},
		auth => $authID,
		id => 3
	};

	$response = $client->call("$server_ip/api_jsonrpc.php", $json);
	#print Dumper ($response);
}

sub logout {
	$json = {
   		jsonrpc => '2.0',
		method => 'user.logout',
		params => [],
		id => 4,
		auth => $authID
  	};
	$client->call("$server_ip/api_jsonrpc.php", $json);
}

exit;
