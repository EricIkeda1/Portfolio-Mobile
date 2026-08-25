# Portfolio Mobile — Flutter + Neon (API Only)

Esta versão exibe somente dados carregados da API.

## Comportamento

- Enquanto carrega: mostra uma tela de carregamento.
- Se a API responder: mostra os dados do Neon.
- Se a API falhar: mostra uma tela de erro com `Tentar novamente`.
- Não existe fallback local com conteúdo antigo.

## Fluxo

```text
Flutter
   ↓
/api/mobile-data
   ↓
Vercel
   ↓
Neon PostgreSQL
```

## Rotas tentadas pelo app

1. `/api/mobile-data`
2. `/api/data`

## URL padrão

```text
https://ericyikedaportfolio5.vercel.app
```

## Executar

```bash
flutter clean
flutter pub get
flutter run
```

## Importante

Garanta que a rota:

```text
https://ericyikedaportfolio5.vercel.app/api/mobile-data
```

esteja publicada e retornando JSON.

A `DATABASE_URL` deve permanecer apenas no backend/Vercel, nunca dentro do Flutter.
