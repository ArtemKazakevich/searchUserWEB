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
});
$('.addAllProduct').on('click', function () {
    var options = $('select.product_1 option').sort().clone();
    $('select.product_2').append(options);
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
});
$('.addAllRole').on('click', function () {
    var options = $('select.role_1 option').sort().clone();
    $('select.role_2').append(options);
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
