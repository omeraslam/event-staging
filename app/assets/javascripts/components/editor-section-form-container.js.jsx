var EditorSectionFormContainer = React.createClass({
    getInitialState: function() {
        return { current_selection: null, eventObj: this.props.eventObj, ticketObj: this.props.ticketObj, onPanelUpdate: this.props.onPanelUpdate, advance_tickets: this.props.advance_tickets}
    },    
    componentWillReceiveProps: function(nextProps) {
        this.setState({current_selection: nextProps.current_selection, eventObj: nextProps.eventObj})
    },

    updateEventItem: function(item) {
        this.props.onUpdateEvent(item);
        this.setState({eventObj: item})

    },
   render: function() {
        if(this.state.current_selection != null) {
            switch(this.state.current_selection["category"]) {
                case 'details':
                    var sectionContent =  <EventDetailsForm header="Edit event settings" subheader="Change of venue? Modify your event details here." eventObj={this.state.eventObj} onPanelUpdate={this.props.onPanelUpdate} />;
                break;
                case 'tickets':
                var sectionContent =  <EventTicketingForm header="Edit Registration + Ticketing settings" subheader="Manage your event registration settings here." eventObj={this.state.eventObj} ticketObj={this.state.ticketObj} onPanelUpdate={this.props.onPanelUpdate}  advance_tickets={this.props.advance_tickets}  />;
                break;
                case 'url':
                var sectionContent =  <EventUrlForm header="Edit URL settings" subheader="Manage your event domain and visibility. Want to use a custom domain/url? We got you. Shoot us a note at support@eventcreate.com" eventObj={this.state.eventObj} onUpdateEventItem={this.updateEventItem} onPanelUpdate={this.props.onPanelUpdate} />;
                break;
                // case 'design':
                // var sectionContent =  <EventDesignForm header="Edit Design settings" subheader="" />;
                // break;
                case 'payment':
                var sectionContent =  <EventPaymentForm header="Edit Payment settings" subheader="Connect to Stripe and choose your country's currency here."  eventObj={this.state.eventObj} onPanelUpdate={this.props.onPanelUpdate} advance_tickets={this.props.advance_tickets} />;
                break;
                default:
                var sectionContent =  <EventDetailsForm header="Edit event settings" subheader="Change of venue? Modify your event details here." eventObj={this.state.eventObj} onPanelUpdate={this.props.onPanelUpdate}  />;
                break;

            }
        } else {
            var sectionContent =  <EventDetailsForm header="Edit event settings" subheader="Change of venue? Modify your event details here." eventObj={this.state.eventObj} onPanelUpdate={this.props.onPanelUpdate} />;
        }

        return (
            <div className="editor-panel">     
               {sectionContent}
            </div>
        )
   } 
});