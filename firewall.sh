#!/bin/bash

# Cores ANSI
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m' # Reset

# Função de animação simples
carregando() {
    echo -ne "${YELLOW}Processando"
    for i in {1..5}; do
        echo -ne "."
        sleep 0.2
    done
    echo -e " ✅${NC}"
}

clear

# Cabeçalho bonito
echo -e "${CYAN}╔════════════════════════════════════════════╗"
echo -e "║      ${YELLOW}${BOLD}🔥  Vencendo o Firewall  🔥${CYAN}       ║"
echo -e "╚════════════════════════════════════════════╝${NC}"
echo

# Menu de opções
echo -e "${GREEN}${BOLD}Escolha uma das opções:${NC}"
echo -e "${CYAN}[1]${NC} Limpar todas as regras"
echo -e "${CYAN}[2]${NC} Aplicar regra número 2"
echo -e "${CYAN}[3]${NC} Aplicar regra número 3"
echo -e "${CYAN}[4]${NC} Aplicar regra número 4"
echo -e "${CYAN}[5]${NC} Visualizar regras atuais"
echo

# Entrada do usuário
read -p "$(echo -e ${YELLOW}">> Escolha uma opção:${NC} ")" opcao
echo

limpa_rules() {

    #animação
    carregando

    # Desativar forward
    sysctl -w net.ipv4.ip_forward=0 > /dev/null 2>&1


    # Zerar log iptables
    echo -n > /var/log/iptables.log

    # Limpar todas regras
    iptables -F

    # Removendo Chains
    iptables -X

    # Zerar contador
    iptables -Z

    # Libera trafego para todas poli�ticas
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT

    echo -e "${GREEN}→ Regras foram limpas com sucesso!${NC}"
}

rules_2(){

    #animação
    carregando

    # Criar Chains
    iptables -N SSH
    iptables -N DNS
    iptables -N HTTP
    iptables -N HTTPs
    iptables -N LogAcceptSSH
    iptables -N LogAcceptDNS
    iptables -N LogAcceptHTTP
    iptables -N LogAcceptHTTPs
    iptables -N LogDrop

    # Libera interface de loopback
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT

    # Entrada e Saída e log SSH
    iptables -A INPUT  -p tcp --dport 22 -j SSH
    iptables -A OUTPUT -p tcp --sport 22 -j SSH
    iptables -A LogAcceptSSH -m limit --limit 10/s --limit-burst 10 -j LOG --log-prefix "[Service SSH]: " --log-level info
    iptables -A SSH -j LogAcceptSSH
    iptables -A SSH -j ACCEPT

    # Entrada e Saída e log DNS
    iptables -A INPUT -p tcp --dport 53 -j DNS
    iptables -A OUTPUT -p tcp --sport 53 -j DNS
    iptables -A LogAcceptDNS -m limit --limit 10/s --limit-burst 10 -j LOG --log-prefix "[Service DNS]: " --log-level info
    iptables -A DNS -j LogAcceptDNS
    iptables -A DNS -j ACCEPT

    # Entrada e Saída e log HTTP
    iptables -A INPUT -p tcp --dport 80 -j HTTP
    iptables -A OUTPUT -p tcp --sport 80 -j HTTP
    iptables -A LogAcceptHTTP -m limit --limit 10/s --limit-burst 10 -j LOG --log-prefix "[Service HTTP]: " --log-level info
    iptables -A HTTP -j LogAcceptHTTP
    iptables -A HTTP -j ACCEPT

    # Entrada e Saída e log HTTPs
    iptables -A INPUT -p tcp --dport 443 -j HTTPs
    iptables -A OUTPUT -p tcp --sport 443 -j HTTPs
    iptables -A LogAcceptHTTPs -m limit --limit 10/s --limit-burst 10 -j LOG --log-prefix "[Service HTTPs]: " --log-level info
    iptables -A HTTPs -j LogAcceptHTTPs
    iptables -A HTTPs -j ACCEPT

    # Rejeitar e Registrar tráfego bloqueado
    iptables -A INPUT -j LogDrop
    iptables -A OUTPUT -j LogDrop
    iptables -A LogDrop -m limit --limit 10/s --limit-burst 10 -j LOG --log-prefix "Rejeitado: " --log-level info
    iptables -A LogDrop -j DROP

    echo -e "${GREEN}→ Regra 2 aplicada.${NC}"
}

rules_3(){

    #animação
    carregando

    # Ativar forward
    sysctl -w net.ipv4.ip_forward=1

    # Acertar as políticas
    iptables -P INPUT DROP
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT

    # Permintir entrada de tráfego
    iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT 
    iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
    iptables -A INPUT -p tcp -m tcp --dport 1024:65535 -j ACCEPT
    echo -e "${GREEN}→ Regra 3 aplicada.${NC}"
}

rules_4(){

    #animação
    carregando

        # Ativar forward
    sysctl -w net.ipv4.ip_forward=1

    # Acertar as políticas
    iptables -P INPUT DROP
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT

    # Permintir entrada de tráfego
    iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT 
    iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT 
    iptables -A INPUT -p tcp -m tcp --sport 53 --dport 1024:65535 -j ACCEPT 
    iptables -A INPUT -p tcp -m tcp --sport 80 --dport 1024:65535 -j ACCEPT 
    iptables -A INPUT -p tcp -m tcp --sport 443 --dport 1024:65535 -j ACCEPT 
    iptables -A OUTPUT -p tcp -m tcp --sport 1024:65535 --dport 80 -j ACCEPT 
    iptables -A OUTPUT -p tcp -m tcp --sport 1024:65535 --dport 443 -j ACCEPT 
    iptables -A OUTPUT -p tcp -m tcp --sport 1024:65535 --dport 53 -j ACCEPT
    echo -e "${GREEN}→ Regra 4 aplicada.${NC}" 

}

show_rules(){
    #animação
    carregando

    echo -e "${CYAN}"
    iptables -L -n -v --line-numbers
    echo -e "${NC}"
}

# Execução
case $opcao in
    1) limpa_rules ;;
    2) rules_2 ;;
    3) rules_3 ;;
    4) rules_4 ;;
    5) show_rules ;;
    *) echo -e "${RED}Opção inválida!${NC}" ;;
esac
