#!/bin/bash

# Função de animação simples 
carregando() {
    echo -n "Processando"
    for i in {1..5}; do
        echo -n "."
        sleep 0.2
    done
    echo " ✅"
}

clear

# Cabeçalho
echo "=============================================="
echo "         🔥  Vencendo o Firewall  🔥"
echo "=============================================="
echo

# Menu de opções
echo "Escolha uma das opções:"
echo "[1] Limpar todas as regras"
echo "[2] Aplicar regra número 2"
echo "[3] Aplicar regra número 3"
echo "[4] Aplicar regra número 4"
echo "[5] Visualizar regras atuais"
echo

# Entrada do usuário
read -p ">> Escolha uma opção: " opcao
echo

limpa_rules() {
    carregando

    sysctl -w net.ipv4.ip_forward=0 > /dev/null 2>&1
    echo -n > /var/log/iptables.log

    iptables -F
    iptables -X
    iptables -Z

    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT

    echo "→ Regras foram limpas com sucesso!"
}

rules_2() {
    carregando

    iptables -N SSH
    iptables -N DNS
    iptables -N HTTP
    iptables -N HTTPs
    iptables -N LogAcceptSSH
    iptables -N LogAcceptDNS
    iptables -N LogAcceptHTTP
    iptables -N LogAcceptHTTPs
    iptables -N LogDrop

    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT

    iptables -A INPUT  -p tcp --dport 22 -j SSH
    iptables -A OUTPUT -p tcp --sport 22 -j SSH
    iptables -A LogAcceptSSH -m limit --limit 10/s --limit-burst 10 -j LOG --log-prefix "[Service SSH]: " --log-level info
    iptables -A SSH -j LogAcceptSSH
    iptables -A SSH -j ACCEPT

    iptables -A INPUT -p tcp --dport 53 -j DNS
    iptables -A OUTPUT -p tcp --sport 53 -j DNS
    iptables -A LogAcceptDNS -m limit --limit 10/s --limit-burst 10 -j LOG --log-prefix "[Service DNS]: " --log-level info
    iptables -A DNS -j LogAcceptDNS
    iptables -A DNS -j ACCEPT

    iptables -A INPUT -p tcp --dport 80 -j HTTP
    iptables -A OUTPUT -p tcp --sport 80 -j HTTP
    iptables -A LogAcceptHTTP -m limit --limit 10/s --limit-burst 10 -j LOG --log-prefix "[Service HTTP]: " --log-level info
    iptables -A HTTP -j LogAcceptHTTP
    iptables -A HTTP -j ACCEPT

    iptables -A INPUT -p tcp --dport 443 -j HTTPs
    iptables -A OUTPUT -p tcp --sport 443 -j HTTPs
    iptables -A LogAcceptHTTPs -m limit --limit 10/s --limit-burst 10 -j LOG --log-prefix "[Service HTTPs]: " --log-level info
    iptables -A HTTPs -j LogAcceptHTTPs
    iptables -A HTTPs -j ACCEPT

    iptables -A INPUT -j LogDrop
    iptables -A OUTPUT -j LogDrop
    iptables -A LogDrop -m limit --limit 10/s --limit-burst 10 -j LOG --log-prefix "Rejeitado: " --log-level info
    iptables -A LogDrop -j DROP

    echo "→ Regra 2 aplicada."
}

rules_3() {
    carregando

    sysctl -w net.ipv4.ip_forward=1 > /dev/null 2>&1

    iptables -P INPUT DROP
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT

    iptables -A INPUT -p tcp --dport 22 -j ACCEPT 
    iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    iptables -A INPUT -p tcp --dport 1024:65535 -j ACCEPT

    echo "→ Regra 3 aplicada."
}

rules_4() {
    carregando

    sysctl -w net.ipv4.ip_forward=1 > /dev/null 2>&1

    iptables -P INPUT DROP
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT

    iptables -A INPUT -p tcp --dport 22 -j ACCEPT 
    iptables -A INPUT -p tcp --dport 80 -j ACCEPT 
    iptables -A INPUT -p tcp --sport 53 --dport 1024:65535 -j ACCEPT 
    iptables -A INPUT -p tcp --sport 80 --dport 1024:65535 -j ACCEPT 
    iptables -A INPUT -p tcp --sport 443 --dport 1024:65535 -j ACCEPT 
    iptables -A OUTPUT -p tcp --sport 1024:65535 --dport 80 -j ACCEPT 
    iptables -A OUTPUT -p tcp --sport 1024:65535 --dport 443 -j ACCEPT 
    iptables -A OUTPUT -p tcp --sport 1024:65535 --dport 53 -j ACCEPT

    echo "→ Regra 4 aplicada."
}

show_rules() {
    carregando
    iptables -L -n -v --line-numbers
}

# Execução
case $opcao in
    1) limpa_rules ;;
    2) rules_2 ;;
    3) rules_3 ;;
    4) rules_4 ;;
    5) show_rules ;;
    *) echo "Opção inválida!" ;;
esac
