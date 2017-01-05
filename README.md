# Telegram-Graph-authenticated
Em caso de dúvida, sugestão ou dificuldade junte-se a nós no <b>Grupo do Telegram</b> <class="noteimportant"><a href="https://telegram.me/email_telegram" class="wikilink2" title="Ingressar no Grupo" rel="nofollow">Gráfico no Email e Telegram</a>.

Envio de alarmes no ZABBIX pelo Telegram com usuário autenticado com gráficos.<br>
<!-- O "How to" foi testado no ZABBIX 2.4, 3.0 e no 3.2 no Debian/Ubuntu e CentOS 6.x e 7. -->

O "How to" foi testado no ZABBIX 2.4, 3.0 e no 3.2 no Debian/Ubuntu e CentOS 6.x e 7, caso não utilize estas distros procure os pacotes descritos para sua necessidade.

#Requisitos:

<b>1 – </b> Executar os comandos abaixo de acordo com sua distro:
<br>
Ex:<br>
<blockquote> <p>Debian/Ubuntu</p> </blockquote>
<b>1.1a </b><pre>$ sudo apt-get install libreadline-dev libconfig-dev libssl-dev libevent-dev libjansson-dev libpython-dev libpython3-all-dev liblua5.2-0 git unzip make<br></pre>

<!--<b>1.2a </b><pre>$ sudo cpan</pre>
<b>1.3a </b><pre> cpan[1]> install WWW::Mechanize JSON::RPC::Client</pre>
<b>1.4a </b>Depois “exit” para sair. -->


<blockquote> <p>CentOS 6.x e 7</p> </blockquote>
<b>1.1b </b><pre>sudo yum install epel-release</pre>
<b>1.2b </b><pre>sudo yum -y update</pre>
<b>1.3b </b><pre>sudo yum install openssl098e.x86_64 python34-libs libconfig-devel readline-devel libevent-devel lua-devel python-devel unzip git make</pre>
<!--<b>1.4b </b><pre>$ sudo cpan</pre>
<b>1.5b </b><pre> cpan[1]> install WWW::Mechanize JSON::RPC::Client</pre>
<b>1.6b </b>Depois “exit” para sair. -->
<b>1.4b </b><pre>ln -s /usr/lib64/liblua-5.1.so /usr/lib64/liblua5.2.so.0 ; ln -s /usr/lib64/libcrypto.so.0.9.8e /usr/lib64/libcrypto.so.1.0.0</pre>

<!--<pre> sudo yum install openssl098e.x86_64 python34-libs libconfig-devel readline-devel libevent-devel lua-devel python-devel unzip git make perl-WWW-Mechanize perl-MIME-Lite perl-JSON-RPC </pre>-->

<br>
<b>2 – </b>Depois faça o download do módulos abaixo:
<br>
<br>
<b>2.1 </b><pre>$ sudo cpan</pre>
<b>2.2 </b><pre> cpan[1]> install WWW::Mechanize JSON::RPC::Client</pre>
<b>2.3 </b><pre>Depois “exit” para sair. </pre>

<b>3 – </b> Faça o download do projeto através do comando:
<pre>git clone https://github.com/sansaoipb/Telegram-Graph-authenticated</pre>

Ao final do download execute os comandos abaixo:
<pre>cd Telegram-Graph-authenticated ; unzip telegram.zip ; sudo rm -rf README.md ; sudo rm -rf telegram.zip ; cd telegram ; sudo chmod +x telegram-cli ; cd ..</pre>

Copie os arquivos para a pasta de scripts do ZABBIX:
<pre>sudo cp -R telegram* PASTA_DE_SCRIPT_DO_ZABBIX</pre>

<b>OBS:</b><br>
<b>1 – </b> Localize onde fica a pasta de script e mude a expressão <code>“PASTA_DE_SCRIPT_DO_ZABBIX”</code> no comando acima de copia.
a pasta pode estar em 2 locais dependendo da forma que você instalou o zabbix (compilando ou por pacote) “/usr/local/share/zabbix/alertscripts/” ou “/usr/lib/zabbix/alertscripts/”.<br>
Caso prefira mudar o local padrão, você pode apontar uma de sua preferência dentro do <code>“zabbix_server.conf”</code>, edite a linha <code>“AlertScriptsPath=”</code> , descomente-a e aponte o novo local que o front irá executar os scripts e dê um restart no serviço do server <code>(zabbix-server)</code>
No meu caso, eu editei para “/etc/zabbix/scripts” e será desta forma que ilustraremos nossos próximos passos.<br>

<b>2 – </b> Vá até a “raiz” (PASTA_DE_SCRIPT_DO_ZABBIX) e execute os comandos abaixo para conceder permissões aos arquivos:
<pre>sudo chmod +x *.pl ; sudo chown -R zabbix. telegram*</pre>

Dentro do diretório <i>“telegram”</i>, edite o arquivo <code>telegram.config</code> na linha abaixo de acordo com sua estrutura:

<pre>config_directory = “/etc/zabbix/scripts/telegram/";</pre>

<b>OBS:</b><br>
Os arquivos necessários estarão em <code>“/etc/zabbix/scripts/telegram/”</code>, e o script <code>telegram.pl</code> na “raiz” onde o zabbix executará, no meu caso como já informei está <code>“/etc/zabbix/scripts/”</code>.


Para iniciarmos a configuração de envio, é preciso logar pela primeira vez manualmente, então entre na pasta de script, que no meu caso é <code>/etc/zabbix/scripts/telegram/”</code> e execute o <code>telegram-cli</code> com o comando abaixo.

<pre>./telegram-cli --rsa-key tg-server.pub --config telegram.config</pre>

Será redirecionado para o console da ferramenta, indicado por um “>”, aguarde até que o texto <code>phone number</code> apareça, depois digite o número de telefone que está cadastrado no telegram, no formato +552244448888 (prefixo para o Brasil, DDD e número), depois que der “Enter” e receberá um código por SMS e no aplicativo <i>(no desktop, no celular ou na versão web, basta estar logado)</i>.
O comando <code>help</code> lista todos os comandos disponíveis, os comandos <code>contact_list</code> e <code>dialog_list</code> carregam sua lista de contatos e as conversas atuais, todos os comandos tem autocomplete usando o TAB.

Para configurarmos o zabbix a enviar mensagens para usuários ou grupos, é necessário executar os comandos <code>user_info</code> ou <code>chat_info</code> seguido do nome do contato ou do grupo conforme está na sua agenda, pegue o “ID” ou o “nome” que aparecerá (os nomes de usuários também tem autocomplete). 

<b>OBS:</b><br>
<b>1 – </b> Se o escolher utilizar o nome cadastrado, precisa atentar a alguns pontos: <br>
<b>1.1 – </b> Caso tenha sobrenome, é necessário ter underscore (_) entre eles; <br>
<b>1.2 – </b> O nome não pode conter acentos, no caso abaixo, se meu nome estivesse com “~” como “Sansão” não funcionaria e eu precisaria ter cadastrado sem ele (assim como fiz);

<b>Ex:</b><br>
<img src="https://lh3.googleusercontent.com/ZEivFtEiU-_ntgKIi-HYQo92nwSqHPj7VAckE_8TjrCCU_lqn4YX1VT29guJn-WREsOSo-s25TRTb5XoLZLNWtmi5CIHQRK-C8JuAYC81gRR8lsjSkep2pAQQ6wCyS8K9Fxh9aoshF7WapjfEq7lzfwlnRrZe2IV8UuhRDUYtSJrbgJiS3YLDQqVDPWNXyF9AEXCP82QDH7b81PuHXVoDR2PKy-X34ZJlYgKcegWE14moFete989JDdhu80Y7H7RVs6RakRwdscJqo3S8t5DWL_wVCPKXWzGUy9KiHXy870ueCDwsdprf7GfBJ-Mprg3wUSVzCSTk6-R3NCG1UcxwM9XBWqVI-RIvWFGclVp4ha0DeORa_31C8r9E-hLI41peXjnSZIRscrDjCZUrC8uh1nqJjFvPh980ZdiiYakt_DwA5EysmML7mcKKiLw1mqSZwbOKcamhDhyRH9367K3a9DSnMzyymwW-w7NCc0cZ6PDT7fUxcR5UBNorHelOSXDck7ugurlwbuaM7g6qs01gF9ZpuQ4QQrMXy4ACCr7Q6pRRSBfv4EympUGP0M3x3MaR_PmTVvh_R10syvn0fH-elzw1Z5aws9uRbd_6FpSm-rp_F2T=w411-h69-no"/><br><br>

Para enviar a mensagem, é preciso usar o ID ou o nome, conforme as estruturas abaixo:<br>
<code>user#129131403</code><br>
<code>Sansao_Simonton</code><br>

Agora o telegram-cli está configurado para utilizar a sua conta. Podemos sair do console dele digitando <code>safe_quit</code> <i>(se já tiver aberto em outro momento)</i> ou <code>quit</code><i>(caso seja a primeira vez que estiver logando)</i>


<h3><a id="user-content-features" class="anchor" href="#features" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" role="img" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path></svg></a> OBS IMPORTANTE:</h3>

<b>1 – </b> O daemon <code><i>“telegram-cli”</i></code> é de SO x64, logo não irá funcionar em SO x86.<br>
<b>2 – </b> Por limitação da aplicação <code><i>“telegram-cli”</i></code>, ainda não é possível enviar mensagem para <b>SUPERGRUPOS</b>, pois não houve atualização depois desta novidade


#Edite os parâmetros:

<ul class="task-list">
<li class="task-list-item"><input type="checkbox" class="task-list-item-checkbox" checked="checked" disabled="disabled"><font><font class=""> “my $server_ip” = 'http://127.0.0.1/zabbix' - URL de acesso ao FRONT com "http://" </font></font></li>
<li class="task-list-item"><input type="checkbox" class="task-list-item-checkbox" checked="checked" disabled="disabled"><font><font class=""> “my $usuario”   = 'Admin';</font></font></li>
<li class="task-list-item"><input type="checkbox" class="task-list-item-checkbox" checked="checked" disabled="disabled"><font><font class=""> “my $senha”     = 'zabbix';</font></font></li>
<li class="task-list-item"><input type="checkbox" class="task-list-item-checkbox" checked="checked" disabled="disabled"><font><font class=""> “my $script    = '/etc/zabbix/scripts/telegram';</font></font></li></ul>

<b>OBS:</b><br>
<b>1 – </b>O usuário que você declarar no campo <i>“my $usuario”</i> precisa ter permissão no mínimo de leitura no ambiente.<br>
<b>2 – </b> coloque o local da pasta de script do seu ambiente no local do caminho <code>/etc/zabbix/scripts/telegram</code>

<h3><a id="user-content-features" class="anchor" href="#features" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" role="img" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path></svg></a>Comando para teste</h3>

Script para realização do teste:<br>
<b>Script, user#ID ou Nome.</b><br>
Exs:<br>
<pre>./telegram-teste.pl user#123456789</pre>
ou
<pre>./telegram-teste.pl Nome_Sobrenome</pre>

<b>OBS:</b><br>
<b>1 – </b>"user#123456789" e "Nome_Sobrenome" são informações fictícias para exemplificar, busque um UserID ou nome de usuário válido em seu ambiente com os comandos já passados para realização do teste;<br>
<b>2 – </b>Se optar por usar o ID, como "user#123456789", “user#” é para quando for usuário, quando for grupo será “chat#” seguido do respectivo ID<br><br>

#Configurando o envio:

Com o script adicionado no local indicado acima, precisamos realizar algumas configurações no Front do ZABBIX, no <i>"Tipo de Mídia"</i>, (em Administração  > Tipo de Mídia) e a <i>"Ação"</i> (em Configuração  > Ações).

<h3><a id="user-content-features" class="anchor" href="#features" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" role="img" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path></svg></a>Tipo de Mídia</h3>

<blockquote> <p>Zabbix 2.4</p> </blockquote>
<img src="https://lh3.googleusercontent.com/-cMFxmglWDvA/V3a0YmX_apI/AAAAAAAAI38/hYdudPHkIL4mUxEKjCw7tjEPUEfz1ormgCCo/s425/TelegramType2.4.JPG"/><br><br>
<blockquote> <p>Zabbix 3.0</p> </blockquote>
<img src="https://lh3.googleusercontent.com/-NLsIJkruJVM/V3a0Ypwn7TI/AAAAAAAAI38/0hU6LsD3AGUYQ98i0V0UIznXrFiz2KnBgCCo/s515/TelegramType3.0.JPG"/><br><br>

<b>OBS:</b><br>
Na versão 3.0, é obrigatório a utilização das macros <code>{ALERT.SENDTO}</code>, <code>{ALERT.SUBJECT}</code> e <code>{ALERT.MESSAGE}</code>, em caso de dúvidas, leia a Documentação 
<class="noteimportant"><a href="https://www.zabbix.com/documentation/3.0/manual/config/notifications/media/script" class="wikilink2" title="Documentação Oficial" rel="nofollow">Aqui</a>.<br><br>

<h3><a id="user-content-features" class="anchor" href="#features" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" role="img" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path></svg></a>Configurando o usuário</h3>

<img src="https://lh3.googleusercontent.com/-EJBhkLJPcKc/V3a0YT2d1nI/AAAAAAAAI38/L3J3QR2EnyMXrnDaeZqwaCkulRasvYthwCCo/s426/TelegramMedia.JPG"/><br>

<h3><a id="user-content-features" class="anchor" href="#features" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" role="img" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path></svg></a>Criando a Ação:</h3>

A “<i>Mensagem Padrão</i>” na aba <b>“<u>Ação</u>”</b> existe somente com uma “exigência”, a primeira linha deve permanecer com as macros/variáveis abaixo ilustradas (<i>as macros/variáveis <b>entre as "#" </b></i>), podendo editar da segunda linha em diante. 
<br>
<h3><a id="user-content-features" class="anchor" href="#features" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" role="img" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path></svg></a>Imagem da Mensagem na Ação:</h3>

<img src="https://lh3.googleusercontent.com/RuDq_CboE2tNdieWYN84JvRfhFIms4umWOzHDOM5hgANwWX-OvyVcuqeDUrZLhq3nlrTY-GQFPSpFg"/><br><br>

<blockquote> Modelo Mensagem Padrão</blockquote>
<pre>
{ITEM.NAME}#{EVENT.ID}#{ITEM.ID}#00C800#3600#\n
IP/DNS: {HOST.CONN}\n
Último valor = {ITEM.LASTVALUE}\n
</pre>

<b>OBS:</b><br>
<i><b>”00C800”</b></i> é a cor da linha (verde) em Hex. sem tralha, e <i><b>”3600”</b></i> é o período do gráfico (1h) em segundo.
<h3><a id="user-content-features" class="anchor" href="#features" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" role="img" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path></svg></a>Resultado da linha de teste:</h3>

<img src="https://lh3.googleusercontent.com/-jij9affl1v0/V3a-HZEQ0eI/AAAAAAAAI4I/X8_XdC7760A94B22ULi6_ANwgW0Ni3YPgCCo/s687/TelegramResult.JPG"/>
<br>
<br>

#Conclusão

1 – Este script é para agilizar a análise e ficar visualmente mais agradável o recebimento dos alarmes.<br><br>
2 – O script realiza uma consulta API mais ampla, detecta automaticamente se o item é de caracter/log/texto, e não envia o gráfico "sem dados" somente o texto, ele dá "ack" no evento e informa quem foi notificado naquela ação. <br><br>
3 – Nos nomes de contatos e grupos, espaços são transformados em underscore (_), tralha/jogo da velha (#), arrobas (@) e contatos com mesmo nome tem um <i>“#1”</i>  acrescentado ao nome (exemplo: Gnu#1, Gnu#2).

