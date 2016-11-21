var EditorPanel = React.createClass({
    getInitialState: function() {
        return { 
            current_selection: this.props.current_selection,
            event_slug: this.props.event_slug,
            category: this.props.category,
            event_id: this.props.event_id

        }
    },
    componentWillReceiveProps: function(nextProps) {
      this.setState({
        current_selection: nextProps.current_selection,
        category: nextProps.category,
        event_id: this.props.event_id
      });
    },

    onAddedNewItem: function() {

    },
    render: function() {
        switch(this.props.category) {
            case 'ticket':
            var SectionForm = <TicketForm current_selection={this.state.current_selection} event_slug={this.state.event_slug} event_id={this.state.event_id} onUpdateMessage={this.props.onUpdateMessage} onAddedNewItem={this.props.onAddedNewItem} onRemovedNewItem={this.props.onRemovedNewItem}  onResetCurrentSelection={this.props.onResetCurrentSelection} advance_tickets={this.props.advance_tickets}  />;
            break;
            case 'coupon':
             var SectionForm = <CouponForm current_selection={this.state.current_selection} event_slug={this.state.event_slug} event_id={this.state.event_id} onUpdateMessage={this.props.onUpdateMessage} onAddedNewItem={this.props.onAddedNewItem} onRemovedNewItem={this.props.onRemovedNewItem} onResetCurrentSelection={this.props.onResetCurrentSelection}  />;
            break;
            case 'question':
            var SectionForm = <QuestionForm current_selection={this.state.current_selection} event_slug={this.state.event_slug} event_id={this.state.event_id} onUpdateMessage={this.props.onUpdateMessage} onAddedNewItem={this.props.onAddedNewItem} onRemovedNewItem={this.props.onRemovedNewItem} onResetCurrentSelection={this.props.onResetCurrentSelection}  ticket_types={this.props.ticket_types}/>;
            break;
            default:
            var SectionForm = <TicketForm current_selection={this.state.current_selection} event_slug={this.state.event_slug} event_id={this.state.event_id} onUpdateMessage={this.props.onUpdateMessage} onAddedNewItem={this.props.onAddedNewItem} onRemovedNewItem={this.props.onRemovedNewItem}  onResetCurrentSelection={this.props.onResetCurrentSelection} advance_tickets={this.props.advance_tickets}  event_date={this.props.event_date}  />;
            break;
        }
  
        return (
            <div className="editor-panel">
                {SectionForm}
            </div>
        )
   } 



});

