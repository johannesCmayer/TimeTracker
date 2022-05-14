// load csv file
function load_csv_file(file) {
    var rawFile = new XMLHttpRequest();
    rawFile.open("GET", file, false);
    rawFile.onreadystatechange = function () {
        if (rawFile.readyState === 4) {
            if (rawFile.status === 200 || rawFile.status == 0) {
                var allText = rawFile.responseText;
                var lines = allText.split("\n");
                for (var i = 0; i < lines.length; i++) {
                    var cells = lines[i].split(",");
                    if (i > 0) {
                        var date = cells[0];
                        var graph = cells[1];
                        add_button(graph, x => null)
                    }
                }
            }
        }
    }
    rawFile.send(null);
}

// add a button to the webpage
function add_button(name, onclick_function) {
    var button = document.createElement("input");
    button.setAttribute("type", "button");
    button.setAttribute("value", name);
    button.setAttribute("onclick", onclick_function);
    document.body.appendChild(button);
}

// add a button to the webpage
function add_text_field(name, value) {
    var text_field = document.createElement("input");
    text_field.setAttribute("type", "text");
    text_field.setAttribute("value", value);
    text_field.setAttribute("name", name);
    return text_field;
}
// add a button to the webpage
function add_text_area(name, value) {
    var text_area = document.createElement("textarea");
    text_area.setAttribute("name", name);
    text_area.setAttribute("rows", "4");
    text_area.setAttribute("cols", "50");
    text_area.innerHTML = value;
    return text_area;
}
// add a button to the webpage
function add_div(name, value) {
    var div = document.createElement("div");
    div.setAttribute("name", name);
    div.innerHTML = value;
    return div;
}
// add a button to the webpage
function add_br() {
    var br = document.createElement("br");
    return br;
}
// add a button to the webpage
function add_hr() {
    var hr = document.createElement("hr");
    return hr;
}