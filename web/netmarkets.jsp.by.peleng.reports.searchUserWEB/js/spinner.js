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