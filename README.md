# 🔥 Vencendo o Firewall - Script Bash

![Shell Script](https://img.shields.io/badge/bash-shell-red?logo=gnubash&style=flat-square)

Um script interativo e colorido em Bash para gerenciar regras de firewall com `iptables`. Ideal para aprendizado de redes, labs de segurança ofensiva e hardening.


---

## 📜 Sobre

Este script permite aplicar diferentes regras de firewall no Linux de forma simples e interativa, ideal para uso em laboratórios de segurança, simulações de CTFs ou aprendizado pessoal.

> 🔥 Desenvolvido com base em conceitos aprendidos no curso de Segurança Ofensiva da [Desec Security](https://www.desecsecurity.com/), como parte de estudos práticos.

---

<h2>🖼️ Demonstração</h2>
<p align="center">
  <img src="https://github.com/Olikere/Vencendo-o-Firewall/blob/main/firewall.gif?raw=true" width="600"
</p>


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
```

---

#### 📚 Créditos

Desec Security – Base de conhecimento

Desenvolvido por [Olikere](https://github.com/Olikere/)
