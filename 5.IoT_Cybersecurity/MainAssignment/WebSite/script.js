// JavaScript to handle smooth scrolling for section links
document.querySelectorAll('#sidepane a').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();

        const pageUrl = this.getAttribute('href');
        fetch(pageUrl)
            .then(response => response.text())
            .then(html => {
                document.getElementById('content').innerHTML = html;
                history.pushState({ page: pageUrl }, '', pageUrl);
            });
    });
});

// Handle popstate event to enable browser back/forward navigation
window.addEventListener('popstate', function (event) {
    const pageUrl = event.state ? event.state.page : 'index.html'; // Default to index.html
    fetch(pageUrl)
        .then(response => response.text())
        .then(html => {
            document.getElementById('content').innerHTML = html;
        });
});
