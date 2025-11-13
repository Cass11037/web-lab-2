package ru.itmo.sludnaya.tags;
import jakarta.servlet.jsp.JspException;
import jakarta.servlet.jsp.JspWriter;
import jakarta.servlet.jsp.tagext.SimpleTagSupport;

import java.io.IOException;
import java.io.StringWriter;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class AccordionTag extends SimpleTagSupport {

    private String id;
    private String mode = "single";
    private String expanded;

    public void setId(String id) {
        this.id = id;
    }

    public void setMode(String mode) {
        this.mode = mode;
    }

    public void setExpanded(String expanded) {
        this.expanded = expanded; 
    }

    @Override
    public void doTag() throws JspException, IOException {
        JspWriter out = getJspContext().getOut();
        StringWriter sw = new StringWriter();
        getJspBody().invoke(sw);
        String bodyContent = sw.toString();

        Pattern pattern = Pattern.compile("\\[TITLE\\](.*?)\\[/TITLE\\]\\s*\\[CONTENT\\](.*?)\\[/CONTENT\\]", Pattern.DOTALL);
        Matcher matcher = pattern.matcher(bodyContent);

        Set<Integer> expandedIndexes = new HashSet<>();
        if (expanded != null && !expanded.isEmpty()) {
            try {
                Arrays.stream(expanded.split(",")).map(String::trim).map(Integer::parseInt).forEach(expandedIndexes::add);
            } catch (NumberFormatException e) {

            }
        }

        StringBuilder html = new StringBuilder();
        html.append("<div id=\"").append(id).append("\" class=\"accordion\">");

        int index = 0;
        while (matcher.find()) {
            String title = matcher.group(1).trim();
            String content = matcher.group(2).trim();
            boolean isExpanded = expandedIndexes.contains(index);

            html.append("<div class=\"accordion-item\">");
            html.append("<div class=\"accordion-title ").append(isExpanded ? "active" : "").append("\">").append(title).append("</div>");
            html.append("<div class=\"accordion-content\" style=\"display: ").append(isExpanded ? "block" : "none").append(";\">");
            html.append("<p>").append(content).append("</p>");
            html.append("</div>");
            html.append("</div>");
            index++;
        }

        html.append("</div>");
        html.append("<script>");
        html.append("(function() {");
        html.append("    var accordion = document.getElementById('").append(id).append("');");
        html.append("    var items = accordion.getElementsByClassName('accordion-item');");
        html.append("    var titles = accordion.getElementsByClassName('accordion-title');");
        html.append("    for (var i = 0; i < titles.length; i++) {");
        html.append("        titles[i].addEventListener('click', function() {");
        html.append("            var content = this.nextElementSibling;");
        html.append("            if (content.style.display === 'block') {");
        html.append("                content.style.display = 'none';");
        html.append("                this.classList.remove('active');");
        html.append("            } else {");
        if ("single".equalsIgnoreCase(mode)) {
            html.append("                for (var j = 0; j < items.length; j++) {");
            html.append("                    items[j].getElementsByClassName('accordion-content')[0].style.display = 'none';");
            html.append("                    items[j].getElementsByClassName('accordion-title')[0].classList.remove('active');");
            html.append("                }");
        }
        html.append("                content.style.display = 'block';");
        html.append("                this.classList.add('active');");
        html.append("            }");
        html.append("        });");
        html.append("    }");
        html.append("})();");
        html.append("</script>");

        out.println(html.toString());
    }
}