// Load shared nav and set active link
function loadNav() {
  fetch('/nav.html')
    .then(r => r.text())
    .then(html => {
      const placeholder = document.getElementById('nav-placeholder');
      if (placeholder) {
        placeholder.innerHTML = html;
        // Highlight current page in nav
        const currentPage = window.location.pathname.split('/').pop() || 'index.html';
        document.querySelectorAll('.nav-tabs li a').forEach(a => {
          const href = a.getAttribute('href').split('/').pop();
          if (href === currentPage) a.classList.add('active');
        });
      }
    });
}

// Mobile menu toggle
function toggleMenu() {
  const tabs = document.querySelector('.nav-tabs');
  if (tabs) tabs.classList.toggle('open');
}

// Scroll reveal
function initReveal() {
  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry, i) => {
      if (entry.isIntersecting) {
        setTimeout(() => entry.target.classList.add('visible'), i * 70);
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.08 });

  document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
}

document.addEventListener('DOMContentLoaded', () => {
  loadNav();
  initReveal();
});
