// JavaScript using jQuery for AJAX and history management
$(document).ready(function () {
    // Function to load content dynamically
    function loadContent(pageUrl) {
        $.ajax({
            url: pageUrl,
            method: 'GET',
            success: function (html) {
                $('#content').html(html);
            },
            error: function () {
                console.error('Error loading content.');
            }
        });
    }

//     // Event listener for sidepane links
//     $('#sidepane a').on('click', function (e) {
//         e.preventDefault();

//         const pageUrl = $(this).attr('href');
//         loadContent(pageUrl);

//         // Update browser history
//         history.pushState({ page: pageUrl }, '', pageUrl);
//     });

//     // Event listener for popstate (back/forward) navigation
//     $(window).on('popstate', function (event) {
//         const pageUrl = event.originalEvent.state ? event.originalEvent.state.page : 'index.html';
//         loadContent(pageUrl);
//     });

//     // Load initial content based on current URL
//     const initialPageUrl = window.location.pathname.substring(1) || 'index.html';
//     loadContent(initialPageUrl);
// });
