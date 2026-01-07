# 💸 Tech Challenge 3 — App Financeiro em Flutter

Aplicativo Flutter para controle financeiro pessoal, com autenticação e armazenamento de dados usando **Firebase**.  
Permite login/cadastro de usuário, visualização de dashboard e gerenciamento de transações (criar, listar e excluir).

---

## 🚀 Tecnologias

- **Flutter** — framework principal  
- **Firebase Core** — inicialização do Firebase  
- **Firebase Auth** — autenticação de usuários  
- **Cloud Firestore** — banco de dados em nuvem  
- **Provider** — gerenciamento de estado  
- **Intl** — formatação de valores e datas  
- **Flutter Localizations** — suporte a português (pt-BR)

---

## ⚙️ Pré-requisitos

Antes de rodar o projeto, garanta que você tem instalado:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versão 3.22 ou superior recomendada)
- [Firebase CLI](https://firebase.google.com/docs/cli)
- [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup?platform=ios)
- Emulador Android/iOS configurado **ou** dispositivo físico conectado

---

## 🧠 Configuração inicial

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/seu-usuario/nome-do-repo.git
   cd nome-do-repo
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Verifique se o Firebase está configurado:**
   O arquivo `lib/firebase_options.dart` já está incluído no projeto.  
   Caso precise gerar novamente:
   ```bash
   flutterfire configure
   ```

4. **Rode o app no emulador ou dispositivo:**
   ```bash
   flutter run
   ```

---

<!-- ## 🧱 Estrutura principal do projeto

```
lib/
 ├─ core/
 │   └─ theme/          → Cores, fontes e estilos globais
 ├─ models/             → Modelos de dados (ex: TransactionModel)
 ├─ pages/              → Telas principais (login, home, cadastro, etc.)
 ├─ widgets/            → Componentes reutilizáveis
 └─ main.dart           → Ponto de entrada do app
```

--- -->

## 🔐 Firebase

O projeto usa Firebase para:
- **Auth:** login/cadastro de usuários  
- **Firestore:** armazenamento das transações  

As configurações do Firebase estão em:
- `firebase.json`  
- `lib/firebase_options.dart`

> ⚠️ Obs: este projeto acadêmico inclui chaves de configuração públicas do Firebase para facilitar a execução local.  
> Elas **não concedem acesso direto** ao banco, pois o acesso é controlado via Firebase Rules.

---

## 🧭 Funcionalidades principais

- [x] Login e cadastro de usuário (Firebase Auth)
- [x] Dashboard com resumo financeiro
- [x] Listagem de transações
- [x] Criação/edição de transações
- [x] Upload e visualização de anexos - Usamos base64 no firestore, pois o plano básico não permitiu o uso do storage
- [x] Filtro e pesquisa de transações

---


## 📝 Licença

Projeto acadêmico — uso educacional apenas.
