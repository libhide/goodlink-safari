const isBookPage = () => {
    const detailListItems = document.querySelectorAll('.content li');
    const searchText = 'ISBN-10';
    let found;
    
    found = [...detailListItems].find(item => item.textContent.includes(searchText));
    
    return {
        isBookPage: found ? true : false,
        isbn: found ? found.innerText.split(':')[1].trim() : ''
    };
};

document.addEventListener("DOMContentLoaded", function(event) {
    const bookPageCheck = isBookPage();
    console.log(bookPageCheck);
                          
    if (bookPageCheck.isBookPage) {
        safari.extension.dispatchMessage("FetchGoodreadsURL", bookPageCheck);
    }
});
