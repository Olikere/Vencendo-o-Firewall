# 🔥 Vencendo o Firewall - Script Bash

![Shell Script](https://img.shields.io/badge/bash-shell-red?logo=gnubash&style=flat-square)

Um script interativo e colorido em Bash para gerenciar regras de firewall com `iptables`. Ideal para aprendizado de redes, labs de segurança ofensiva e hardening.

---

## 📋 Funcionalidades

- 🧹 Limpar completamente as regras do firewall
- 🔒 Aplicar regras específicas para SSH, DNS, HTTP e HTTPS
- 📊 Visualizar as regras atuais com `iptables -L`
- 🎨 Interface colorida e com animação de carregamento
- ⚙️ Uso simples e rápido

---

## 📦 Requisitos

- Sistema Linux com `iptables`
- Terminal com suporte a cores ANSI
- Permissão de superusuário (`sudo`)

---

## 🚀 Como usar

```bash
git clone https://github.com/Olikere/Vencendo-o-Firewall
cd Vencendo-o-Firewall
chmod +x firewall.sh
sudo ./firewall.sh
