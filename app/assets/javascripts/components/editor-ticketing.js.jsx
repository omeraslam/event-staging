var EditorTicketing = React.createClass({
    getInitialState: function() {
        return {items: this.props.items, current_selection: this.props.current_selection, event_slug: this.props.event_slug, category: 'ticket'}
    },
    render: function() {
        return (
            <div className="editor-tool editor-panel-left-nav" id="editor-tool-ticketing" >
              <EditorSection items={this.state.items} current_selection={this.state.current_selection} event_slug={this.state.event_slug} category={this.state.category} advance_tickets={this.props.advance_tickets}  />
            </div>
        )
    } 
});