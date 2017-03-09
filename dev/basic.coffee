window.customElements.define "ce-portal", require "../src/portal.coffee"
createView = require "ceri-dev-server/lib/createView"
module.exports = createView
  mixins: [
    require "ce/#if"
  ]
  structure: template 1, """
    <div class="container" style="background-color:lightgrey;">
    <p #text=within container></p>
    <a href="https://github.com/cerijs/ceri-portal/blob/master/dev/basic.vue" #text=source></a>
    <br/><br/>
    <button @click="togglePortal" #text="toggle portal to body"></button>
    <ce-portal #ref="portal1" #if="toggled">
      <p #ref="p1" #text="teleported to body"></p>
    </ce-portal>
    <ce-portal #ref="portal2" target=".container2">
      <p #ref="p2" #text="teleported to container2 by selector"></p>
    </ce-portal>
    </div>
    <div #ref="c2" class="container2" style="background-color: lightgrey;margin-top: 20px;">
      <p #text="within container2"></p>
    </div>

  """
  data: ->
    toggled: true
  methods:
    togglePortal: -> @toggled = !@toggled

  tests: (el) ->
    describe "portal", ->
      after ->
        el.remove()
      it "should default to document.body", ->
        el.p1.parentNode.should.equal document.body

      it "should work with selector string", ->
        el.p2.parentNode.should.equal el.c2

      it "should work #if", (done) ->
        el.p1.parentNode.should.equal document.body
        el.toggled = false
        el.$nextTick ->
          should.not.exist el.p1.parentNode
          el.toggled = true
          el.$nextTick ->
            el.p1.parentNode.should.equal document.body
            done()
