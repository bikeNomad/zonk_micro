Slides/slides.html: presentation.html presentation_wrapper.html
	sed -f insert_presentation.sed presentation_wrapper.html > Slides/slides.html
	rm presentation.html

presentation.html: slideshow/Slides.html 
	sed -n -f make_slideshow.sed slideshow/Slides.html > presentation.html

slideshow/Slides.html: Slides.markdown
	bash -ci 'slideshow -o slideshow Slides.markdown'

# slideshow/Slides.html
