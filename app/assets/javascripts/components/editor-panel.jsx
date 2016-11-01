var EditorPanel = React.createClass({
    getInitialState: function() {
        return { 
            current_selection: this.props.current_selection,
            event_slug: this.props.event_slug,
            category: this.props.category,
            onUpdateMessage: this.props.onUpdateMessage,
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




    render: function() {
        var category = 'ticket'
        switch(this.props.category) {
            case 'ticketing':
            var SectionForm = <TicketForm current_selection={this.state.current_selection} event_slug={this.state.event_slug} event_id={this.state.event_id} onUpdateMessage={this.props.onUpdateMessage} />;
            break;
            case 'coupons':
             var SectionForm = <CouponForm current_selection={this.state.current_selection} event_slug={this.state.event_slug} event_id={this.state.event_id} onUpdateMessage={this.props.onUpdateMessage} />;
            break;
            case 'questions':
            var SectionForm = <QuestionForm current_selection={this.state.current_selection} event_slug={this.state.event_slug} event_id={this.state.event_id} onUpdateMessage={this.props.onUpdateMessage} />;
            break;
            default:
            var SectionForm = <TicketForm current_selection={this.state.current_selection} event_slug={this.state.event_slug} event_id={this.state.event_id} onUpdateMessage={this.props.onUpdateMessage} />;
            break;
        }
  
        return (
            <div className="editor-panel">
                {SectionForm}
            </div>
        )
   } 



});

