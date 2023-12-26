if (sessionStorage.getItem('banner') === 'hide') {
  document.querySelector('.cookies-banner-modal').style.display = 'none';
} else {
  document.querySelector('.close').addEventListener('click', () => {
    sessionStorage.setItem('banner', 'hide')
    document.querySelector('.cookies-banner-modal').style.display = 'none';
  })
}
