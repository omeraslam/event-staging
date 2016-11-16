var EditorSettings = React.createClass({
    getInitialState: function() {
        return {onUpdateEvent: this.props.onUpdateEvent, advance_tickets: this.props.advance_tickets, scid: this.props.scid, tickets_on: this.props.tickets_on}
    },
    render: function() {
        return (
             <div className="editor-tool editor-panel-left-nav" id="editor-tool-details">

                <EditorSectionContainer eventObj={this.props.eventObj} onUpdateMessage={this.props.onUpdateMessage} ticketObj={this.props.ticketObj} onUpdateEvent={this.props.onUpdateEvent} advance_tickets={this.props.advance_tickets} scid={this.props.scid}  tickets_on={this.props.tickets_on} onTicketUpdate={this.props.onTicketUpdate} />

             </div>

        )
    }
});