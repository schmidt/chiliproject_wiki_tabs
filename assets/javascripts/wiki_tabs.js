/*globals window, Event, $, $$, console*/
(function () {
    var addLine, removeLine, addListenersToRow;

    addLine = function (e) {
        e.preventDefault();

        var newId = new Date().getTime(),
            newTr = $('wiki_tabs_tr_template').cloneNode(true);

        newTr.id = null;
        newTr.innerHTML = newTr.innerHTML.replace(/NEW_RECORD/g, newId);

        addListenersToRow(newTr);

        $(this).up('tr').insert({after: newTr});
    };

    removeLine = function (e) {
        e.preventDefault();

        var tr = $(this).up('tr'),
            deleteInput = tr.down('input._destroy');

        tr.hide();

        if (deleteInput) {
            deleteInput.setValue('1');
        }
    };

    addListenersToRow = function (row) {
        $(row).select(".wiki_tabs_add_line").each(function (e) {
            Event.observe(e, 'click', addLine);
        });
        $(row).select(".wiki_tabs_remove_line").each(function (e) {
            Event.observe(e, 'click', removeLine);
        });
    };

    window.initWikiTabs = function () {
        $('wiki_tabs_table').select('tbody tr').each(addListenersToRow);
    };
}());
