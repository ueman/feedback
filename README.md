<p align="center">
  <img src="https://raw.githubusercontent.com/ueman/feedback/master/img/feedback.svg" max-height="100" alt="Feedback" />
</p>

<p align="center">
  <a href="https://pub.dev/packages/feedback"><img src="https://img.shields.io/pub/v/feedback.svg" alt="pub.dev"></a>
  <a href="https://github.com/ueman/feedback/actions/workflows/feedback.yml"><img src="https://github.com/ueman/feedback/actions/workflows/feedback.yml/badge.svg" alt="feedback workflow"></a>
  <a href="https://codecov.io/gh/ueman/feedback"><img src="https://codecov.io/gh/ueman/feedback/branch/master/graph/badge.svg" alt="code coverage"></a>
  <a href="https://github.com/ueman#sponsor-me"><img src="https://img.shields.io/github/sponsors/ueman" alt="Sponsoring"></a>
  <a href="https://pub.dev/packages/feedback/score"><img src="https://img.shields.io/pub/likes/feedback" alt="likes"></a>
  <a href="https://pub.dev/packages/feedback/score"><img src="https://img.shields.io/pub/popularity/feedback" alt="popularity"></a>
  <a href="https://pub.dev/packages/feedback/score"><img src="https://img.shields.io/pub/points/feedback" alt="pub points"></a>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/ueman/feedback/master/img/ff.png" height="100" alt="Flutter Favorite" />
</p>

<p align="center">

[![Vídeo da biblioteca da semana](https://img.youtube.com/vi/yjsN2Goe_po/0.jpg)](https://www.youtube.com/watch?v=yjsN2Goe_po "feedback (Package of the Week)")

</p>

Uma biblioteca do Flutter feita para conseguir melhores feedbacks. Ela permite que o usuário dê feedbacks 
interativos diretamente de dentro do app, ao fazer capturas de tela do app, sendo possível adicionar texto também.

<p align="center">
  <img src="https://raw.githubusercontent.com/ueman/feedback/master/img/example_0.1.0-beta.gif" width="200" alt="Imagem de exemplo">
</p>

## Demo

Um exemplo interativo no navegador está disponível aqui: <a href="https://ueman.github.io/feedback/"><img src="https://img.shields.io/badge/Try-Flutter%20Web%20demo-blue" alt="Online demo"></a>. Também contém um pequeno tutorial sobre como usar essa biblioteca

## Motivação

Geralmente é difícil conseguir uma ótima experiência de usuário. O aspecto mais importante
de criar uma boa experiência do usuário é conseguir e ouvir ao feedback do usuário.
Grupos de foco são uma solução para esse problema, mas são caros. Outra solução é usar essa biblioteca e obter feedback diretamente dos seus usuários.
Essa biblioteca é leve e fácil de entregar, e faz com que seja realmente fácil para seus usuários enviarem feedbacks úteis para você.

Ao obter o feedback com uma imagem comentada é muito mais fácil para você ter um bom entendimento do problema dos seus usuários
com alguma certa funcionalidade ou tela do seu app. Assim como o ditado "Uma imagem vale mais do que mil palavras" porque uma descrição em forma de texto
pode ser interpretada de muitas formas, o que faz com que a compreensão seja mais difícil.
understand.

### Plugins

Dependendo do seu caso de uso existe uma grande variedade de soluções.
Aqui estão algumas delas:

| Plugin                         | Package                          |
|--------------------------------|--------------------------------|
| GitLab Issue                   | [feedback_gitlab](https://pub.dev/packages/feedback_gitlab) |
| Sentry User Feedback           | [feedback_sentry](https://pub.dev/packages/feedback_sentry) |


| Target                         | Notes                          |
|--------------------------------|--------------------------------|
| Subir para um servidor             | Para subir o feedback para um servidor você deve usar como exemplo um [MultipartRequest](https://pub.dev/documentation/http/latest/http/MultipartRequest-class.html). |
| Compartilhar via platform share dialog | [share_plus on pub.dev](https://pub.dev/packages/share_plus). Também é mostrado no exemplo. |
| Firebase | [Firestore](https://pub.dev/packages/cloud_firestore), [Cloud Storage](https://pub.dev/packages/firebase_storage), [Database](https://pub.dev/packages/firebase_database)
|   Jira | Jira tem uma [REST API to create issues and upload files](https://developer.atlassian.com/server/jira/platform/jira-rest-api-examples/#creating-an-issue-examples) |
| Trello | Trello tem uma [REST API to create issues and upload files](https://developer.atlassian.com/cloud/trello/rest/api-group-actions/) |
| E-Mail | Você pode usar o email do usuário como no [in the sample app](https://github.com/ueman/feedback/blob/master/feedback/example/lib/main.dart#L147-L160) para enviar o feedback para você mesmo usando o [flutter_email_sender](https://pub.dev/packages/flutter_email_sender) plugin. |

Se você tiver um código de exemplo sobre como subir isso para uma plataforma, eu agradeceria um pull request para o example app.

## 📣  Mantenedor

Olá, eu sou Jonas Uekötter. Eu criei esse incrível software. Visite o meu [GitHub profile](https://github.com/ueman) e me siga no [Twitter](https://twitter.com/ue_man). Se você gostou, por favor deixe um like ou marque com uma estrela no Github.

## Contribuidores

<a href="https://github.com/ueman/feedback/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=ueman/feedback" />
</a>
