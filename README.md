# Telegram-Graph-authenticated
Em caso de dúvida, sugestão ou dificuldade junte-se a nós no <b>Grupo do Telegram</b> <class="noteimportant"><a href="https://telegram.me/joinchat/B7JjiwivOYVKq5gPNDqFSA" class="wikilink2" title="Ingressar no Grupo" rel="nofollow">Gráfico no Email e Telegram</a>.

Envio de alarmes no ZABBIX pelo Telegram com usuário autenticado com gráficos.<br>
<!-- O "How to" foi testado no ZABBIX 2.4 e no 3.0 com base em Debian. -->

O "How to" foi testado no ZABBIX 2.4 e no 3.0 e está baseado em Debian/Ubuntu, caso não utilize estas distros procure os pacotes descritos para sua necessidade.

<br>
<br>

<b>1 – </b> Baixar os módulos abaixo:
<br>
Ex:<br>
<blockquote> <p>Debian / Ubuntu</p> </blockquote>
<pre>$ sudo apt-get install libreadline-dev libconfig-dev libssl-dev libevent-dev libjansson-dev libpython-dev libpython3-all-dev git unzip make<br></pre>

<pre>$ sudo cpan</pre>
<pre> cpan[1]> install WWW::Mechanize JSON::RPC::Client</pre>
Depois “exit” para sair.


<!--<blockquote> <p>CentOS 6.x e 7</p> </blockquote>
<pre>yum install perl-WWW-Mechanize perl-MIME-Lite perl-JSON-RPC</pre>
<blockquote> <p>CentOS 6.x e 7</p> </blockquote>
<pre>sudo yum install epel-release</pre>
<pre>sudo yum install telegram-cli.x86_64 openssl-devel libconfig-devel readline-devel git unzip make perl-WWW-Mechanize perl-MIME-Lite perl-JSON-RPC </pre> -->

<b>2 – </b> Faça o download do script <code>“telegram.pl“</code> e dos arquivos necessários através do comando:
<pre>git clone https://github.com/sansaoipb/Telegram-Graph-authenticated</pre>

Ao final do download execute os comandos abaixo:
<pre>cd Telegram-Graph-authenticated ; unzip telegram.zip ; sudo rm -rf README.md ; sudo rm -rf telegram.zip ; cd telegram ; sudo chmod +x telegram-cli ; cd ..</pre>

Copie o script e a pasta para a pasta de scripts do ZABBIX:
<pre>sudo cp -R telegram* PASTA_DE_SCRIPT_DO_ZABBIX</pre>
<b>OBS:</b><br>
<b>1 – </b> Localize onde fica a pasta de script e mude a expressão <code>“PASTA_DE_SCRIPT_DO_ZABBIX”</code> no comando acima de copia.
a pasta pode estar em 2 locais dependendo da forma que você instalou o zabbix (compilando ou por pacote) “/usr/local/share/zabbix/alertscripts/” ou “/usr/lib/zabbix/alertscripts/”.<br>
Caso prefira mudar o local padrão, você pode apontar uma de sua preferência dentro do <code>“zabbix_server.conf”</code>, edite a linha <code>“AlertScriptsPath=”</code> , descomente-a e aponte o novo local que o front irá executar os scripts e dê um restart no serviço do server <code>(zabbix-server)</code>
No meu caso, eu editei para “/etc/zabbix/scripts” e será desta forma que ilustraremos nossos próximos passos.<br>
<b>2 – </b> Vá até a “raiz” (PASTA_DE_SCRIPT_DO_ZABBIX) e execute os comandos abaixo para conceder permissões aos arquivos:
<pre>sudo chmod +x telegram.pl ; sudo chown -R zabbix. telegram*</pre>

Dentro do diretório <i>“telegram”</i>, edite o arquivo <code>telegram.config</code> na linha abaixo de acordo com sua estrutura:

<pre>config_directory = “/etc/zabbix/scripts/telegram/";</pre>

<b>OBS:</b> Os arquivos necessários estarão em <code>“/etc/zabbix/scripts/telegram/”</code>, e o script <code>telegram.pl</code> na “raiz” onde o zabbix executará, no meu caso como já informei está <code>“/etc/zabbix/scripts/”</code>.


Para iniciarmos a configuração de envio, é preciso logar pela primeira vez manualmente, então entre na pasta de script, que no meu caso é <code>/etc/zabbix/scripts/telegram/”</code> e execute o <code>telegram-cli</code> com o comando abaixo.
<pre>./telegram-cli --rsa-key tg-server.pub --config telegram.config</pre>

Será redirecionado para o console da ferramenta, indicado por um “>”, aguarde até que o texto <code>phone number</code> apareça, depois digite o número de telefone que está cadastrado no telegram, no formato +552244448888 (prefixo para o Brasil, DDD e número), depois que der “Enter” e receberá um código por SMS e no aplicativo <i>(no desktop, no celular ou na versão web, basta estar logado)</i>.
O comando <code>help</code> lista todos os comandos disponíveis, os comandos <code>contact_list</code> e <code>dialog_list</code> carregam sua lista de contatos e as conversas atuais, todos os comandos tem autocomplete usando o TAB.

Para configurarmos o zabbix a enviar mensagens para usuários ou grupos, execute <code>user_info</code> ou <code>chat_info</code> seguido do nome do contato ou do grupo conforme está na sua agenda, e pegue o ID que aparecerá (os nomes de usuários também tem autocomplete). 

<b>Ex:</b><br>
<img src="https://lh3.googleusercontent.com/-LuDCum9gPPo/V3nNSlyr3JI/AAAAAAAAI5Q/fGqNP7E8u3sb0gTD-6Qza3GacVIySqanwCCo/s404/user_info.JPG"/><br><br>

Para receber mensagem, preciso cadastrar com esta estrutura: <code>user#129131403</code>

Agora o telegram-cli está configurado para utilizar a sua conta. Podemos sair do console dele digitando <code>safe_quit</code> ou <code>quit</code>

#Edite os parâmetros do script:

<ul class="task-list">
<li class="task-list-item"><input type="checkbox" class="task-list-item-checkbox" checked="checked" disabled="disabled"><font><font class=""> “my $server_ip” = 'http://127.0.0.1/zabbix' - URL de acesso ao FRONT com "http://" </font></font></li>
<li class="task-list-item"><input type="checkbox" class="task-list-item-checkbox" checked="checked" disabled="disabled"><font><font class=""> “my $usuario”   = 'Admin';</font></font></li>
<li class="task-list-item"><input type="checkbox" class="task-list-item-checkbox" checked="checked" disabled="disabled"><font><font class=""> “my $senha”     = 'zabbix';</font></font></li>
<li class="task-list-item"><input type="checkbox" class="task-list-item-checkbox" checked="checked" disabled="disabled"><font><font class=""> “my $script    = '/etc/zabbix/scripts/telegram';</font></font></li>
</ul>
<b>OBS:</b><br>
<b>1 – </b>O usuário que você declarar no campo <i>“my $usuario”</i> precisa ter permissão no mínimo de leitura no ambiente.<br>
<b>2 – </b> coloque o local da pasta de script do seu ambiente no local do caminho <code>/etc/zabbix/scripts/telegram</code>

<h3><a id="user-content-features" class="anchor" href="#features" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" role="img" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path></svg></a>Comando para teste</h3>

A estrutura do comando para realização de teste é:<br>
<b>Script, user#ID, Assunto, Nome-do-Item#ID-do-Item#CorpoDaMsg.</b><br>
Ex:<br>
<pre>./telegram.pl user#123456789 "Assunto" "NomeDoItem#123456#CorpoDaMsg"<br></pre>
<b>OBS:</b><br>
<b>1 – </b>”123456” é um número fictício para exemplificar, busque um ItemID válido em seu ambiente para realização do teste;<br>
<b>2 – </b>”123456789” é um número fictício para exemplificar, busque um ID válido em seu ambiente com os comandos já passados para realização do teste;<br>
<b>3 – </b>"user#123456789" quando for usuário será “user#”, quando for grupo será “chat#” seguido do respectivo ID<br>

#Configurando o envio

Com o script adicionado no local indicado acima, precisamos realizar algumas configurações no Front do ZABBIX, no <i>"Tipo de Mídia"</i>, (em Administração  > Tipo de Mídia) e a <i>"Ação"</i> (em Configuração  > Ações).

<h3><a id="user-content-features" class="anchor" href="#features" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" role="img" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path></svg></a>Tipo de Mídia</h3>
<blockquote> <p>Zabbix 2.4</p> </blockquote>
<img src="https://lh3.googleusercontent.com/-cMFxmglWDvA/V3a0YmX_apI/AAAAAAAAI38/hYdudPHkIL4mUxEKjCw7tjEPUEfz1ormgCCo/s425/TelegramType2.4.JPG"/><br><br>
<blockquote> <p>Zabbix 3.0</p> </blockquote>
<img src="https://lh3.googleusercontent.com/-NLsIJkruJVM/V3a0Ypwn7TI/AAAAAAAAI38/0hU6LsD3AGUYQ98i0V0UIznXrFiz2KnBgCCo/s515/TelegramType3.0.JPG"/><br><br>
<b>OBS:</b> Na versão 3.0, é obrigatório a utilização das macros <code>{ALERT.SENDTO}</code>, <code>{ALERT.SUBJECT}</code> e <code>{ALERT.MESSAGE}</code>, em caso de dúvidas, leia a Documentação 
<class="noteimportant"><a href="https://www.zabbix.com/documentation/3.0/manual/config/notifications/media/script" class="wikilink2" title="Documentação Oficial" rel="nofollow">Aqui</a>.<br><br>

<h3><a id="user-content-features" class="anchor" href="#features" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" role="img" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path></svg></a>Configurando o usuário</h3>

<img src="https://lh3.googleusercontent.com/-EJBhkLJPcKc/V3a0YT2d1nI/AAAAAAAAI38/L3J3QR2EnyMXrnDaeZqwaCkulRasvYthwCCo/s426/TelegramMedia.JPG"/><br>

<h3><a id="user-content-features" class="anchor" href="#features" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" role="img" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path></svg></a>Criando a Ação:</h3>

A “<i>Mensagem Padrão</i>” na aba <b>“<u>Ação</u>”</b> está sendo executada no formato “HTML”, então você pode realizar a formatação que desejar, somente com uma “exigência”, por uma limitação da aplicação, as macros/variáveis abaixo ilustradas, devem permanecer uma ao lado da outra separadas com <code>“tralha”(#)</code>, depois da <i>“segunda #”</i>, pode ser adicionado o que desejar, como abaixo
<br>
<h3><a id="user-content-features" class="anchor" href="#features" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" role="img" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path></svg></a>Imagem da Mensagem na Ação:</h3>

<img src="https://lh3.googleusercontent.com/-WMFZj7-U5HY/V3a0YQ63WOI/AAAAAAAAI38/kWKdgzr6haIsI8RW89cHbA79Wec_j7jzQCCo/s505/TelegramAction.JPG"/><br><br>

<blockquote> Modelo Mensagem Padrão</blockquote>
<pre>{ITEM.NAME}#{ITEM.ID}#Último valor = {ITEM.LASTVALUE}.</pre>


<h3><a id="user-content-features" class="anchor" href="#features" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" role="img" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path></svg></a>Resultado da linha de teste:</h3>

<img src="https://lh3.googleusercontent.com/-jij9affl1v0/V3a-HZEQ0eI/AAAAAAAAI4I/X8_XdC7760A94B22ULi6_ANwgW0Ni3YPgCCo/s687/TelegramResult.JPG"/>
<br>
<br>

#Conclusão

1 – Este script é para agilizar a analise e ficar visualmente mais agradável o recebimento dos alarmes.<br><br>
2 – O script realiza uma consulta API mais ampla, e detecta automaticamente se o item é de caractere/log/texto, e não envia o gráfico "sem dados", somente o texto. <br><br>
3 – Nos nomes de contatos e grupos, espaços são transformados em underline (_), tralha/jogo da velha (#), arrobas (@) e contatos com mesmo nome tem um #1acrescentado ao nome (exemplo: Gnu#1, Gnu#2).

