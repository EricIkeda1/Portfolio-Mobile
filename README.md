# Portfolio Mobile — Flutter

Versão expandida do portfólio mobile com identidade Material 3 Expressive.

## Navegação principal

- Início
- Projetos
- Sobre

## Menu Explorar

- Habilidades
- Experiência
- Formação
- GitHub
- Serviços
- Contato
- Tema claro/escuro

Cada página possui uma composição própria para evitar repetição visual.

## Dados dinâmicos

O app continua consumindo:

- `/api/mobile-data` para conteúdo do portfólio/Neon
- GitHub público para o status e estatísticas públicas

## Executar

```bash
flutter clean
flutter pub get
flutter run
```

## Android

```bash
flutter build apk --release
```


## Correção Java/Gradle no Windows

O Android Gradle Plugin deste projeto requer Java 17 ou superior.

O projeto já está configurado para usar, por padrão:

```text
C:\Program Files\Android\Android Studio\jbr
```

Se esse caminho for diferente no seu computador, execute na raiz do projeto:

```powershell
.\corrigir-java.ps1
```

ou dê duplo clique em:

```text
corrigir-java.bat
```

O script procura automaticamente Android Studio/JDK 17+ e configura o Flutter e o Gradle.
