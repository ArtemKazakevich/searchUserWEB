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

<!--Изделие. Для фильтрации option через input-->
let filterProduct = function () {
    let input = document.getElementById('inputProduct');

    input.addEventListener('keyup', function () {
        let filter = input.value.toLowerCase(),
            filterElements = document.querySelectorAll('#selectProduct option');

        filterElements.forEach(item => {
            if (item.innerHTML.toLowerCase().indexOf(filter) > -1) {
                item.style.display = '';
            } else {
                item.style.display = 'none';
            }
        })

    })

};
filterProduct();

<!--Изделие. script для работы с кнопками удаления и добавления из одного select в другой-->
$('.addProduct').on('click', function () {
    var options = $('select.product_1 option:selected').sort().clone();
    $('select.product_2').append(options);

    <!--Чистка Input после нажатия кнопки-->
    var val = $('#inputProduct').val();

    if(val.length >= 1){
        $('#inputProduct').val('');
    }
});
$('.removeProduct').on('click', function () {
    $('select.product_2 option:selected').remove();
});
$('.removeAllProduct').on('click', function () {
    $('select.product_2').empty();
});


<!--Роль. Для фильтрации option через input-->
let filterRole = function () {
    let input = document.getElementById('inputRole');

    input.addEventListener('keyup', function () {
        let filter = input.value.toLowerCase(),
            filterElements = document.querySelectorAll('#selectRole option');

        filterElements.forEach(item => {
            if (item.innerHTML.toLowerCase().indexOf(filter) > -1) {
                item.style.display = '';
            } else {
                item.style.display = 'none';
            }
        })

    })

};
filterRole();

<!--Роль. script для работы с кнопками удаления и добавления из одного select в другой-->
$('.addRole').on('click', function () {
    var options = $('select.role_1 option:selected').sort().clone();
    $('select.role_2').append(options);

    <!--Чистка Input после нажатия кнопки-->
    var val = $('#inputRole').val();

    if(val.length >= 1){
        $('#inputRole').val('');
    }
});
$('.removeRole').on('click', function () {
    $('select.role_2 option:selected').remove();
});
$('.removeAllRole').on('click', function () {
    $('select.role_2').empty();
});


<!--Выделение добавленных option в форме, для отправки в сервлет-->
// Выбрать все
$('#js-button-add').click(function(){
    $('#select_1 option').prop('selected', true);
    $('#select_2 option').prop('selected', true);
});