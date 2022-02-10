<!--Код для добавления input в form, чтобы передать через него значение нажатой кнопки(Удаление или Добавление)-->
let $delete = document.getElementById('js-button-add_1');
let $add = document.getElementById('js-button-add_2');

$add.addEventListener('click', function () {
    var $input = document.createElement('input');
    $input.type = 'text';
    $input.name = 'typeButton';
    $input.value = 'buttonAdd';
    $input.hidden = true;
    this.appendChild($input);

    <!--Выделение всех option в select-->
    $('#select_1 option').prop('selected', true);
    $('#select_2 option').prop('selected', true);
}, true);

$delete.addEventListener('click', function () {
    var $input = document.createElement('input');
    $input.type = 'text';
    $input.name = 'typeButton';
    $input.value = 'buttonDelete';
    $input.hidden = true;
    this.appendChild($input);

    <!--Выделение всех option в select-->
    $('#select_1 option').prop('selected', true);
    $('#select_2 option').prop('selected', true);
}, true);