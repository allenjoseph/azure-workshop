document.addEventListener('DOMContentLoaded', () => {
  fetch('http://52.141.221.130/customers/api/customers ', {
    method: 'GET',
    headers: new Headers({
      'Ocp-Apim-Subscription-Key':
        '1d29b02c07b34b3ebf6fdba2017e1fbf;product=unlimited'
    })
  })
    .then(res => res.json())
    .then(data => {
      data.forEach(element => {
        const node = document.createElement('li');
        node.innerText = element;
        document.querySelector('#customers').appendChild(node);
      });
    });

  fetch('http://52.141.221.130/products/api/products ', {
    method: 'GET',
    headers: new Headers({
      'Ocp-Apim-Subscription-Key':
        '1d29b02c07b34b3ebf6fdba2017e1fbf;product=unlimited'
    })
  })
    .then(res => res.json())
    .then(data => {
      data.forEach(element => {
        const node = document.createElement('li');
        node.innerText = element;
        document.querySelector('#products').appendChild(node);
      });
    });
});
