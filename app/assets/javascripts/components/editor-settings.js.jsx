var EditorSettings = React.createClass({
    render: function() {
        return (
             <div className="editor-tool editor-panel-left-nav" id="editor-tool-details">

                <EditorSectionContainer eventObj={this.props.eventObj} ticketObj={this.props.ticketObj} />

             </div>

        )
    }
});