# Flutter + Vercel + Neon + GitHub

## Arquitetura segura

```text
Flutter
  |-- API do portfólio --> Vercel --> Neon PostgreSQL
  `-- status GitHub -----> GitHub API pública
```

A `DATABASE_URL` deve existir apenas no backend/Vercel. Nunca coloque a connection string dentro de `lib/`, `--dart-define`, APK ou repositório público.

## Banco Neon

O schema esperado está em:

```text
integration/neon/schema.sql
```

Configure `DATABASE_URL` nas Environment Variables do projeto Vercel com a connection string do projeto `Portfoliov5`.

## Endpoint do portfólio

Copie:

```text
integration/vercel/mobile-data.ts
```

para o projeto web:

```text
api/mobile-data.ts
```

O Flutter usa por padrão:

```text
https://ericyikedaportfolio5.vercel.app/api/mobile-data
```

## Status do GitHub

O Flutter consulta o perfil público `EricIkeda1` e os eventos públicos mais recentes. O texto não representa presença online em tempo real; ele é calculado pela data da última atividade pública:

- menos de 24h: `Ativo hoje`
- menos de 3 dias: `Ativo recentemente`
- menos de 7 dias: `Atividade nesta semana`
- menos de 30 dias: `Atividade recente`
- acima disso: `Sem atividade pública recente`

Também há um endpoint opcional em `integration/vercel/github-status.ts` caso você queira centralizar a consulta no backend e usar cache.
