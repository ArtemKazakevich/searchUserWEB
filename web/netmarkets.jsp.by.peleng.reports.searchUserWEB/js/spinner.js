var s = document.getElementById('page-preloader');

document.getElementById('js-button').onclick = function () {
    s.style.display = "block";
}

document.getElementById('js-button-1').onclick = function () {
    s.style.display = "block";
}

document.getElementById('js-button-2').onclick = function () {
    s.style.display = "block";
}

document.getElementById('js-button-3').onclick = function () {
    s.style.display = "block";
}

document.getElementById('js-button-4').onclick = function () {
    s.style.display = "block";
}

document.getElementById('js-button-add_1').onclick = function () {
    s.style.display = "block";
}

document.getElementById('js-button-add_2').onclick = function () {
    s.style.display = "block";
}

document.getElementById('js-button-add').onclick = function () {
    s.style.display = "block";
}

<!--Спиннер-->
document.body.onload = function() {

    setTimeout(function() {
        var preloader = document.getElementById('page-preloader'); // находим наш id - page-preloader
        if( !preloader.classList.contains('done') )
        {
            preloader.classList.add('done'); // добавляем класс done, если его нет
        }
    }, 1000); // preloader исчезнет через 1с
}