function reply(res_title, res_textarea) {
	var title = document.getElementById('title');
	var textarea = document.getElementById('textarea');
	title.value = 'Re:' +  res_title;
	textarea.value = '>' + res_textarea;
}
