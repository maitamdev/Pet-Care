function toggleMobileMenu() {
    var navMenu = document.querySelector('.nav-menu');
    if (navMenu) {
        navMenu.classList.toggle('show');
    }
}

window.addEventListener('scroll', function () {
    var header = document.querySelector('.header');
    if (header) {
        if (window.scrollY > 50) {
            header.style.boxShadow = '0 4px 20px rgba(0, 0, 0, 0.08)';
        } else {
            header.style.boxShadow = 'none';
        }
    }
});

document.addEventListener('DOMContentLoaded', function () {
    var anchorLinks = document.querySelectorAll('a[href^="#"]');
    anchorLinks.forEach(function (link) {
        link.addEventListener('click', function (e) {
            var targetId = this.getAttribute('href');
            if (targetId === '#') return;
            var targetElement = document.querySelector(targetId);
            if (targetElement) {
                e.preventDefault();
                targetElement.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
});
