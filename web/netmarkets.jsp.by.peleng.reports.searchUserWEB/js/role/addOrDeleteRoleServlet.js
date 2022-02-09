<!--Код для добавления input в form, чтобы передать через него значение нажатой кнопки(Удаление или Добавление)-->
let $form = document.getElementById('formBlock');

let $delete = document.getElementById('js-button-add_1');
let $add = document.getElementById('js-button-add_2');

$add.addEventListener('click', function () {
    var $input = document.createElement('input');
    $input.type = 'text';
    $input.name = 'typeButton';
    $input.value = 'buttonAdd';
    this.appendChild($input);
}, true);

$delete.addEventListener('click', function () {
    var $input = document.createElement('input');
    $input.type = 'text';
    $input.name = 'typeButton';
    $input.value = 'buttonDelete';
    this.appendChild($input);
}, true);