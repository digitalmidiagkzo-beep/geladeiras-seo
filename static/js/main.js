/* =============================================
   GELADEIRAS USADAS BH — MAIN JS
   ============================================= */

'use strict';

// === CAROUSEL ===
let currentSlide = 0;

function changeSlide(dir) {
  const slides = document.querySelectorAll('.carousel-slide');
  const dots = document.querySelectorAll('.dot');
  if (!slides.length) return;

  slides[currentSlide].classList.remove('active');
  slides[currentSlide].setAttribute('aria-hidden', 'true');
  dots[currentSlide]?.classList.remove('active');
  dots[currentSlide]?.setAttribute('aria-selected', 'false');

  currentSlide = (currentSlide + dir + slides.length) % slides.length;

  slides[currentSlide].classList.add('active');
  slides[currentSlide].setAttribute('aria-hidden', 'false');
  dots[currentSlide]?.classList.add('active');
  dots[currentSlide]?.setAttribute('aria-selected', 'true');
}

function goToSlide(index) {
  const dir = index - currentSlide;
  changeSlide(dir || 0);
  currentSlide = index;
  // Re-sync
  document.querySelectorAll('.carousel-slide').forEach((s, i) => {
    s.classList.toggle('active', i === index);
    s.setAttribute('aria-hidden', i === index ? 'false' : 'true');
  });
  document.querySelectorAll('.dot').forEach((d, i) => {
    d.classList.toggle('active', i === index);
    d.setAttribute('aria-selected', i === index ? 'true' : 'false');
  });
}

// Auto-advance carousel
function initCarousel() {
  const slides = document.querySelectorAll('.carousel-slide');
  if (slides.length > 1) {
    setInterval(() => changeSlide(1), 4500);
  }

  // Touch/swipe support
  const carousel = document.getElementById('carousel');
  if (!carousel) return;

  let startX = 0;
  carousel.addEventListener('touchstart', e => {
    startX = e.touches[0].clientX;
  }, { passive: true });

  carousel.addEventListener('touchend', e => {
    const diff = startX - e.changedTouches[0].clientX;
    if (Math.abs(diff) > 50) changeSlide(diff > 0 ? 1 : -1);
  }, { passive: true });
}

// === FAQ ACCORDION ===
function initFaq() {
  const items = document.querySelectorAll('.faq-item');
  items.forEach(item => {
    const btn = item.querySelector('.faq-question');
    if (!btn) return;
    btn.addEventListener('click', () => {
      const isOpen = item.classList.contains('open');
      // Close all
      items.forEach(i => {
        i.classList.remove('open');
        i.querySelector('.faq-question')?.setAttribute('aria-expanded', 'false');
      });
      // Toggle current
      if (!isOpen) {
        item.classList.add('open');
        btn.setAttribute('aria-expanded', 'true');
      }
    });
  });
}

// === MOBILE MENU ===
function initMobileMenu() {
  const toggle = document.querySelector('.menu-toggle');
  const nav = document.querySelector('.site-nav');
  if (!toggle || !nav) return;

  toggle.addEventListener('click', () => {
    const expanded = toggle.getAttribute('aria-expanded') === 'true';
    toggle.setAttribute('aria-expanded', String(!expanded));
    nav.classList.toggle('open');
  });
}

// === LAZY LOADING (native fallback) ===
function initLazyLoad() {
  if ('loading' in HTMLImageElement.prototype) return; // native support
  const imgs = document.querySelectorAll('img[loading="lazy"]');
  if (!('IntersectionObserver' in window)) {
    imgs.forEach(img => { if (img.dataset.src) img.src = img.dataset.src; });
    return;
  }
  const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const img = entry.target;
        if (img.dataset.src) img.src = img.dataset.src;
        observer.unobserve(img);
      }
    });
  });
  imgs.forEach(img => observer.observe(img));
}

// === SMOOTH SCROLL ANCHORS ===
function initSmoothScroll() {
  document.querySelectorAll('a[href^="#"]').forEach(link => {
    link.addEventListener('click', e => {
      const target = document.querySelector(link.getAttribute('href'));
      if (target) {
        e.preventDefault();
        target.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    });
  });
}

// === WHATSAPP UTM ===
function addWhatsAppUtm() {
  const params = new URLSearchParams(window.location.search);
  const utm = params.get('utm_source') || 'organico';
  document.querySelectorAll('a[href*="wa.me"]').forEach(link => {
    try {
      const url = new URL(link.href);
      const text = url.searchParams.get('text') || '';
      if (!text.includes('utm')) {
        url.searchParams.set('text', text + ` [via: ${utm}]`);
        link.href = url.toString();
      }
    } catch (_) {}
  });
}

// === INIT ===
document.addEventListener('DOMContentLoaded', () => {
  initCarousel();
  initFaq();
  initMobileMenu();
  initLazyLoad();
  initSmoothScroll();
  addWhatsAppUtm();
});
// CAROUSEL
var cur = 0;
function muda(d) {
  var slides = document.querySelectorAll('.slide');
  var dots = document.querySelectorAll('.dot');
  if (!slides.length) return;
  slides[cur].classList.remove('active');
  if(dots[cur]) dots[cur].classList.remove('on');
  cur = (cur + d + slides.length) % slides.length;
  slides[cur].classList.add('active');
  if(dots[cur]) dots[cur].classList.add('on');
}
function vai(i) { muda(i - cur); }
setInterval(function(){ muda(1); }, 5000);

// FAQ
document.querySelectorAll('.faq-q').forEach(function(btn) {
  btn.addEventListener('click', function() {
    var item = this.closest('.faq-item');
    var aberto = item.classList.contains('open');
    document.querySelectorAll('.faq-item').forEach(function(el){ el.classList.remove('open'); });
    if (!aberto) item.classList.add('open');
  });
});
