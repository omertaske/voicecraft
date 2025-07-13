const formData = {email: ``, message: ''};
const formDataKey = `feedback-form-state`;
const feedbackForm = document.querySelector('.feedback-form');

function parseData(key = 'empty') {
  const data = localStorage.getItem(key);
  try {
    return JSON.parse(data);
  } catch (error) {
    console.log(error.name);
    return null;
  }
}

function loadData() {
  const parsedData = parseData(formDataKey) || {};

  feedbackForm.elements.email.value = parsedData.email || '';
  feedbackForm.elements.message.value = parsedData.message || '';
}

loadData();

feedbackForm.addEventListener('input', () => {
  const userEmail = feedbackForm.elements.email.value.trim();
  const userMessage = feedbackForm.elements.message.value.trim();

  formData.email = userEmail;
  formData.message = userMessage;

  localStorage.setItem(formDataKey, JSON.stringify(formData));
});

feedbackForm.addEventListener('submit', event => {
  const email = feedbackForm.elements.email.value;
  const message = feedbackForm.elements.message.value;

  if (email === '' || message === '') {
    alert('Fill please all fields');
    event.preventDefault();
  } else {
    event.preventDefault();
    console.log(JSON.parse(localStorage.getItem(formDataKey)));
    localStorage.removeItem(formDataKey);
    feedbackForm.reset();
  }
});
