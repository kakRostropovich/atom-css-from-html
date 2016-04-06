[![apm](https://img.shields.io/apm/dm/css-from-html.svg)](https://atom.io/packages/project-manager)
[![apm](https://img.shields.io/apm/v/css-from-html.svg)]()

# Atom package: CSS from HTML

![css-from-html](https://raw.githubusercontent.com/kakRostropovich/atom-css-from-html/master/description.gif)

**RUS:**

Этот плагин для Atom позволяет скопировать в буфер обмена из HTML-документа список CSS-классов в виде готового каркаса для написания стилей.

Возможности:
- Классы не дублируются
- Ситуации, когда у элемента несколько классов (вроде class="block modificator context") обрабатываются таким образом:
    - Первый класс считается базовым, добавляется в буфер, если его еще не было
    - После базового класса в буфер добавляется полная конструкция ".block.modificator.context", если базовый класс был добавлен раньше - то переносится под него.
    - Все классы .modificator .context (количество не ограничено) добавляются по отдельности, если еще не присутствуют в буфере.
- Если в HTML-документе выделить фрагмент и запустить плагин, то в буфер попадут только классы из выделенной области. Если выделения нет - классы берутся из всего документа.

## Как использовать:
Скопировать стили в буфер обмена можно комбинацией клавиш **shift+ctrl+alt+h**

## Планы на новые версии:

- v1.0.0 - добавить индентацию в зависимости от вложенности элементов
- v2.0.0 - добавить настройки внешнего вида получаемого CSS

**EN:**

TODO
