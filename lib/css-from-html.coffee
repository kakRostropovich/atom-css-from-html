CssFromHtmlView = require './css-from-html-view'
htmlParser = require 'html-parser'
{CompositeDisposable} = require 'atom'

module.exports = CssFromHtml =
  cssFromHtmlView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @cssFromHtmlView = new CssFromHtmlView(state.cssFromHtmlViewState)
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'css-from-html:start': => @start()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @cssFromHtmlView.destroy()

  destroy: ->
    return if @destroyed
    @subscriptions?.dispose()
    @subscriptions = null
    @destroyed = true

  serialize: ->
    cssFromHtmlViewState: @cssFromHtmlView.serialize()

  start: ->

    {clipboard} = atom
    {write, readWithMetadata} = clipboard

    editor = atom.workspace.getActiveTextEditor()
    selectedText = editor.getSelectedText()

    if selectedText
        text = selectedText
    else
        text = editor.getText()

    result = ''

    prepareText = htmlParser.parse(text, {

        attribute: (name, value) ->
            if name == 'class'

                # TODO: If element has @1-@n classes for custom tabulation
                if value.indexOf('@') > 1
                    regex = /\s@\w+/
                    tabsCount = parseFloat( value.match(regex)[0].slice(2))
                    value = value.replace(regex, '')
                    tabsLine = ''


                # Parse @n class to tab width
                setTabs = (@n) ->
                    tabs = ''

                    if tabs != 0
                        while @n > 0
                            tabs += "    "
                            @n = @n - 1

                    return tabs

                tabsLine = setTabs(tabsCount)

                createSelector = (classes) ->
                    return tabsLine + '.' + classes + ' {\n' + tabsLine + '\n' + tabsLine + '}\n\n'

                # If one class in selector
                if value.indexOf(' ') == -1
                    oneClassLine = createSelector(value)

                    if result.indexOf(oneClassLine) == -1
                        result += oneClassLine

                # If few classes in selector
                else
                    valueArray = value.split(' ')
                    firstClass = valueArray[0]
                    valueJoined = valueArray.join('.')
                    firstClassLine = createSelector(firstClass)
                    allClassesLine = createSelector(valueJoined)

                    for classElement in valueArray
                      classElementLine = createSelector(classElement)
                      if result.indexOf(classElementLine) == -1
                        result += classElementLine

                    if result.indexOf(allClassesLine) == -1

                        # If first class (base) added before
                        startPosition = result.indexOf(firstClassLine)
                        lengthLine = firstClassLine.length
                        startLine = result.slice(0, startPosition + lengthLine)
                        finishLine = result.slice( startPosition + lengthLine )
                        if result.indexOf(allClassesLine) == -1
                            result = startLine + allClassesLine + finishLine

    })

    clipboard.write(result)
    result = ''
    text = ''
