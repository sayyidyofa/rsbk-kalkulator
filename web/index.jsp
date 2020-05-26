<%--
  Created by IntelliJ IDEA.
  User: Yoffa
  Date: 25/05/2020
  Time: 08.00
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%  %>
<html>
<head>
    <title>Fomantic UI Calculator</title>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/fomantic-ui@2.8.4/dist/semantic.min.css"/>
    <style>
        .interface {
            margin-top: 30px;
        }

        .interface .btnGroup {
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .interface button {
            background: dodgerblue;
            color: white;
            border: none;
            outline: none;
            font-size: 25px;
            width: 70px;
            height: 70px;
            cursor: pointer;
        }
    </style>
</head>
<body>
<div class="interface">
    <div class="ui centered four column grid">
        <div class="column">
            <div class="ui card">
                <div class="content">
                    <div class="header">Fomantic UI Calculator</div>
                </div>
                <div class="extra content">
                    <form action="${pageContext.request.contextPath}/CalcServlet" method="post" class="ui form">
                        <div class="field">
                            <div class="ui fluid input">
                                <label for="expression"></label>
                                <input placeholder="" readonly type="text" name="expression" id="expression">
                            </div>
                        </div>
                        <div class="field">
                            <div class="ui fluid input">
                                <label for="answer"></label>
                                <input placeholder="" readonly type="text" name="answer" id="answer">
                            </div>
                        </div>
                    </form>
                    <br>
                    <div class="btnGroup">
                        <button name="number" value="7">7</button>
                        <button name="number" value="8">8</button>
                        <button name="number" value="9">9</button>
                        <button name="operation" value="+">+</button>
                    </div>
                    <div class="btnGroup">
                        <button name="number" value="4">4</button>
                        <button name="number" value="5">5</button>
                        <button name="number" value="6">6</button>
                        <button name="operation" value="-">-</button>
                    </div>
                    <div class="btnGroup">
                        <button name="number" value="1">1</button>
                        <button name="number" value="2">2</button>
                        <button name="number" value="3">3</button>
                        <button name="operation" value="*">*</button>
                    </div>
                    <div class="btnGroup">
                        <button name="reset" value="CE">CE</button>
                        <button name="number" value="0">0</button>
                        <button name="recentAnswer">ANS</button>
                        <button name="operation" value="/">/</button>
                    </div>
                    <div class="btnGroup">
                        <button name="execute" value="=">=</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<p id="sessionVar" style="visibility: hidden">${sessionScope.answer}</p>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/jquery@3.3.1/dist/jquery.min.js"></script>
<script type="text/javascript"
        src="https://cdn.jsdelivr.net/npm/sweetalert2@9.10.10/dist/sweetalert2.all.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/fomantic-ui@2.8.4/dist/semantic.min.js"></script>
<script type="text/javascript">
    let expression = "";
    let recentAnswer = 0;

    document.querySelectorAll('button').forEach((element, index) => {
        element.addEventListener('click', (e)=>{
            e.preventDefault();
            switch (e.target.name) {
                case "number":
                    handleUserInput(e.target.value);
                    break;
                case "operation":
                    handleUserInput(e.target.value);
                    break;
                case "execute":
                    validateExpression(expression).then(handleSubmit).catch(toastError);
                    break;
                case "reset":
                    resetExpression().then(renderExpression);
                    break;
                case "recentAnswer":
                    handleUserInput(getRecentAnswer());
                    break;
                default:
                    toastError("Not implemented yet!")
                    break;
            }
        });
    });

    window.addEventListener('load', (e) => {
        handleServerResponse(getRecentAnswer());
    });

    function handleUserInput(userInput) {
        updateExpression(userInput)
            /*.then(validateExpression)*/
            .then(renderExpression)
            .catch(toastError);
    }

    function handleServerResponse(serverResponse) {
        if (serverResponse !== null && serverResponse !== undefined && serverResponse !== '')
            if (isNaN(Number(serverResponse))) toastError(serverResponse);
            else isThisANumber(Number(serverResponse))
                ? renderAnswer(serverResponse).then(updateRecentAnswer)
                : toastError(serverResponse)
    }

    function handleSubmit(data) {
        document.querySelector('form').requestSubmit();
    }

    function getRecentAnswer() {
        return document.getElementById('sessionVar').textContent.toString();
    }

    async function validateExpression(expression) {
        // https://stackoverflow.com/a/24234339/8885105
        //if (!/^[-+]?[0-9]+([-+*/]+[-+]?[0-9]+)*$/.test(expression) /*&& !/^[^*!/+-]+$/.test(expression)*/) throw "Invalid expression!";
        //else return expression;
        //return /^\-?[0-9](([-+/*][0-9]+)?([.,][0-9]+)?)*?$/.test(expression);
        return expression;
    }

    async function renderAnswer(answer) {
        document.getElementById("answer").value = answer;
        return answer;
    }

    function renderExpression(theExpression) {
        document.getElementById("expression").value = theExpression;
    }

    function updateRecentAnswer(answer) {
        recentAnswer = answer;
    }

    async function updateExpression(theExpression) {
        expression += theExpression;
        return expression;
    }

    async function resetExpression() {
        expression = "";
        return expression;
    }

    function toastError(errorMessage) {
        try {
            $('body').toast({title: 'Error!',class: 'error', message: errorMessage});
        } catch (e) {
            alert(e);
        }
    }

    // https://stackoverflow.com/questions/20169217/how-to-write-isnumber-in-javascript
    function isThisANumber(n) {
        let isNumber = function isNumber(value) {
            return typeof value === 'number' && isFinite(value);
        }
        let isNumberObject = function isNumberObject(n) {
            return (Object.prototype.toString.apply(n) === '[object Number]');
        }
        return isNumber(n) || isNumberObject(n);
    }

    //document.getElementById("yoyoy").addEventListener('click',(e)=>{fetch("/CalcServlet", {method:"GET"}).then(()=>{alert("response here");window.location.reload();})});
    /*window.addEventListener('load', (event)=>{
      fetch("/CalcServlet", {method:"GET"}).then(()=>{alert("response here");window.location.reload();});
    });*/
</script>
</body>
</html>
