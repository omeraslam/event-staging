var EditorSettings = React.createClass({
    getInitialState: function() {
        return {onUpdateEvent: this.props.onUpdateEvent, advance_tickets: this.props.advance_tickets}
    },
    render: function() {
        return (
             <div className="editor-tool editor-panel-left-nav" id="editor-tool-details">

                <EditorSectionContainer eventObj={this.props.eventObj} ticketObj={this.props.ticketObj} onUpdateEvent={this.props.onUpdateEvent} advance_tickets={this.props.advance_tickets} />

             </div>

        )
    }
});