var EditorTicketing = React.createClass({
    render: function() {
        return (
            <div className="editor-tool editor-panel-left-nav" id="editor-tool-ticketing" >
              <EditorSection items={this.props.items} current_selection={this.props.current_selection} event={this.props.event} />
            </div>
        )
    } 
});