---
layout: default
title: Dominic Orchard
sitemap:
    priority: 0.9
    changefreq: monthly
---

{% assign collection = site.pubs | sort: "date" | group_by: "type" %}

<img src="images/face.jpg" style="float:right;padding:20px;" width="30%" alt="Dominic Orchard's photo">

<h2>Dominic Orchard</h2>
I am a lecturer in the <a href="https://research.kent.ac.uk/programming-languages-systems/">Programming Languages and Systems</a> group at the
<a href="https://www.kent.ac.uk/computing">School of Computing</a>,
<a href="http://www.kent.ac.uk"> University of Kent</a>.
<br><br>
My research is at the intersection of <strong>types</strong>, <strong>semantics</strong>,
and <strong>logic</strong>, with a focus on <strong>programming languages</strong> and <strong>verification</strong>.

#### Current Projects

My current project is
on <a href="https://granule-project.github.io/">The Granule
Project</a> where I am studying graded logics, models, and type theories.

#### Research interests

- Keywords: Programming languages, type theory, category theory, and logic in computer science.
- [AMS Classes](/AMS-classes.html)

#### Publications

{% for group in collection %}
    {% if group.name != 'drafts' %}

    <h4>Papers in Proceedings <span class="badge">{{ group.items | size }}</span></h4>

    <ul class="list-group">

      {% assign pubs = group.items | sort: "date" | reverse %}
      {% for publication in pubs %}

        <li class="list-group-item">
          {{ publication.authors | join: ', ' }}.
          <strong>{{ publication.title }}</strong>.
          {% if group.name == 'article' %}
            {% if publication.journal %} {{ publication.journal }}, {% endif %}
            {% if publication.volume %} volume {{ publication.volume }}. {% endif %}
            {% if publication.number %} number {{ publication.number }}. {% endif %}
            {% if publication.pages %} Pages {{ publication.pages }}. {% endif %}
            {% if publication.date %} {{ publication.date | date: "%d %B %Y" }}.
	    {% elsif publication.year %} {{ publication.year }}.
	    {% endif %}          
          {% endif %}
          {% if publication.publisher %}{{ publication.publisher }}.{% endif %}
          {% if publication.note %}<i>{{ publication.note }}.</i>{% endif %}
          {% if publication.resource %}
            {% if publication.resource.bibtex %}
	      [<a href="{{ publication.resource.bibtex }}">Bibtex</a>]
            {% endif %}
            {% if publication.resource.slides %}
	      [<a href="{{ publication.resource.slides }}">Slides</a>]
            {% endif %} 
	    {% if publication.resource.type == 'doi' %}
	      <a href="http://dx.doi.org/{{ publication.resource.value }}">doi: {{ publication.resource.value }}</a>
            {% elsif publication.resource.type == 'doi-report' %}
              <a href="http://dx.doi.org/{{ publication.resource.value }}">doi: {{ publication.resource.value }}</a>
              [<a href="{{ publication.resource.report-url }}">PDF ({{ publication.resource.report-note }})</a>]
            {% elsif publication.resource.type == 'doi-pdf' %}
              <a href="http://dx.doi.org/{{ publication.resource.value }}">doi: {{ publication.resource.value }}</a>
              [<a href="{{ publication.resource.pdf-url }}">PDF</a>]                              
	    {% elsif publication.resource.type == 'url' %}
	      <a href="{{ publication.resource.value }}">{{ publication.resource.value }}</a>
            {% elsif publication.resource.type == 'pdf-report' %}
	      [<a href="{{ publication.resource.pdf-url }}">PDF</a>]
              [<a href="{{ publication.resource.report-url }}">PDF ({{ publication.resource.report-note }})</a>]
            {% elsif publication.resource.type == 'pdf' %}
	      [<a href="{{ publication.resource.pdf-url }}">PDF</a>]
            {% endif %}
          {% endif %}
        </li>
        {% endfor %}        
    </ul>
    {% endif %}
{% endfor %}  

#### Conference and workshop service

<h4>Contact Information</h4>


