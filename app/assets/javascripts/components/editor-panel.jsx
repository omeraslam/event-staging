var EditorPanel = React.createClass({
    getInitialState: function() {
        return { 
            current_selection: this.props.current_selection,
            event_slug: this.props.event_slug

        }
    },
    componentWillReceiveProps: function(nextProps) {
      this.setState({
        current_selection: nextProps.current_selection 
      });
    },




    render: function() {
        var category = 'ticket'
        if(category == 'ticket') {
            var SectionForm = <TicketForm current_selection={this.state.current_selection} event_slug={this.state.event_slug}/>;
        } else {
             var SectionForm = <CouponForm current_selection={this.state.current_selection} event_slug={this.state.event_slug}/>;
        }
  
        return (
            <div className="editor-panel">
                {SectionForm}
            </div>
        )
   } 



});

