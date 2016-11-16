var EditorSectionContainer = React.createClass({
    getInitialState: function() {
        return { items: this.props.items, current_selection: this.props.current_selection, eventObj: this.props.eventObj, ticketObj: this.props.ticketObj, onUpdateEvent:this.props.onUpdateEvent, message: this.props.message, advance_tickets: this.props.advance_tickets, scid: this.props.scid, tickets_on: this.props.tickets_on }
    },
    getDefaultProps: function() {
        return { items: [], current_selection: null, eventObj: null, message: ''}
    },

    componentDidMount: function() {
   
    },
    componentWillReceiveProps: function(nextProps) {

        this.setState({eventObj: nextProps.eventObj})
    },

    selectItem: function(item) {
        this.setState({current_selection: item, message: null})

    },
    refreshNav: function() {

    },
    render: function() {
       // alert(this.state.message);
        return (
           <div>
                <EditorAsideSectionNav handleSelectItem={this.selectItem} />
                <EditorSectionFormContainer current_selection={this.state.current_selection} eventObj={this.state.eventObj} ticketObj={this.state.ticketObj} onUpdateEvent={this.props.onUpdateEvent} onUpdateMessage={this.props.onUpdateMessage} advance_tickets={this.props.advance_tickets} scid={this.props.scid} tickets_on={this.props.tickets_on} onTicketUpdate={this.props.onTicketUpdate} />
            </div>
        )
   } 
});