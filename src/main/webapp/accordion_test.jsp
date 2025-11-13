<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://itmo.ru/weblab/ui" %>
<html>
<head>
    <title>Accordion Tag Examples</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            color: #333;
            line-height: 1.6;
            background-color: #fdfdfd;
            padding: 20px 40px;
        }
        h1, h2 {
            color: #222;
            font-weight: 600;
        }
        .accordion {
            border: 1px solid #ddd;
            border-radius: 5px;
            width: 700px;
            overflow: hidden;
            margin-bottom: 30px;
        }
        .accordion-item {}
        .accordion-item:last-child .accordion-title {
            border-bottom: none;
        }
        .accordion-title {
            padding: 15px 20px;
            cursor: pointer;
            background-color: #f9f9f9;
            font-weight: 600;
            color: #2c3e50;
            border-bottom: 1px solid #ddd;
            transition: background-color 0.3s ease;
            position: relative;
        }
        .accordion-title::before {
            content: '+';
            position: absolute;
            right: 20px;
            font-size: 1.2em;
            color: rgb(144, 29, 49);
        }
        .accordion-title.active::before {
            content: '−';
        }
        .accordion-title:hover {
            background-color: #f1f1f1;
        }
        .accordion-title.active {
            background-color: #f1f1f1;
            color: rgb(144, 29, 49);
        }
        .accordion-content {
            padding: 10px 20px;
            background-color: #fff;
            display: none;
        }
    </style>
</head>
<body>

    <h1>Примеры работы тега "Аккордеон"</h1>

    <h2>Вопросы про JSP (режим "multiple")</h2>
    <ui:accordion id="jsp-faq" mode="multiple" expanded="0">
        [TITLE]Что такое JSP?[/TITLE]
        [CONTENT]JavaServer Pages (JSP) — это технология, которая позволяет разработчикам создавать динамически генерируемые веб-страницы. JSP-файлы компилируются в сервлеты, что позволяет встраивать Java-код непосредственно в HTML-разметку.[/CONTENT]
        [TITLE]В чем отличие JSP от сервлетов?[/TITLE]
        [CONTENT]Основное отличие в подходе. JSP ориентирован на представление (HTML с вкраплениями Java), тогда как сервлет — это Java-код, который генерирует HTML. JSP удобнее для верстки, сервлеты — для сложной логики.[/CONTENT]
        [TITLE]Что такое скриплеты?[/TITLE]
        [CONTENT]Скриплеты— это фрагменты Java-кода, вставляемые прямо в JSP-страницу. Их использование считается устаревшей практикой. Современный подход — использовать Expression Language (EL) и JSTL (JSP Standard Tag Library).[/CONTENT]
    </ui:accordion>

    <h2>Вопросы про Сервлеты (режим "single")</h2>
    <ui:accordion id="servlet-faq" mode="single" expanded="1">
        [TITLE]Что такое сервлет?[/TITLE]
        [CONTENT]Сервлет — это Java-класс, который расширяет возможности сервера. Он принимает запросы от клиента (обычно HTTP-запросы) и генерирует ответы. Сервлеты работают на стороне сервера в контейнере сервлетов.[/CONTENT]
        [TITLE]Каков жизненный цикл сервлета?[/TITLE]
        [CONTENT]Жизненный цикл сервлета состоит из трех основных методов: init() (вызывается один раз при создании), service() (вызывается для обработки каждого запроса) и destroy() (вызывается один раз перед удалением сервлета).[/CONTENT]
        [TITLE]Что такое doGet() и doPost()?[/TITLE]
        [CONTENT]Это методы, которые обрабатывают HTTP-запросы GET и POST соответственно. Метод service() определяет тип запроса и вызывает соответствующий do...() метод.[/CONTENT]
    </ui:accordion>

</body>
</html>