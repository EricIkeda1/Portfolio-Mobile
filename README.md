# Portfolio Mobile — Flutter + Neon

Aplicativo Flutter baseado nas seções do portfólio web.

## Seções

- Início
- Projetos
- Sobre
- Habilidades
- Experiência
- Contato

## Conteúdo sincronizado com Neon

O aplicativo está preparado para carregar:

- `portfolio_settings`
  - Quem sou eu
  - Foto de perfil
  - WhatsApp
  - E-mail
  - GitHub

- `portfolio_projects`
  - Nome
  - Tipo
  - Descrição
  - Tags
  - Destaques
  - Link
  - Cor
  - Imagem
  - Ordem
  - Publicação

## Segurança

Não coloque `DATABASE_URL` no Flutter.

Use:

Flutter -> Vercel API -> Neon

Veja:

```text
integration/README.md
```

## Executar

```bash
flutter clean
flutter pub get
flutter run
```

## API

Por padrão o app usa:

```text
https://ericyikedaportfolio5.vercel.app
```

e tenta:

```text
/api/mobile-data
/api/data
```

Se a API não estiver disponível, o aplicativo continua abrindo com uma cópia local dos dados atuais e mostra um aviso para tentar novamente.

## Status automático pelo GitHub

A tela inicial consulta `https://github.com/EricIkeda1` através da API pública do GitHub e mostra um status baseado na última atividade pública. Isso não é um detector de presença online em tempo real.

## Connection string do Neon

Por segurança, a connection string não fica no Flutter. Configure-a como `DATABASE_URL` somente na Vercel/API. O arquivo `integration/vercel/.env.example` contém apenas um placeholder.
