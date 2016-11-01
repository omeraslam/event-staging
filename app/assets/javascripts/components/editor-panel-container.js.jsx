var EditorPanelContainer = React.createClass({
    getInitialState: function() {
        return { current_selection: this.props.current_selection,
                 event_slug: this.props.event_slug,
                 category: this.props.category, message: this.props.message,
                 event_id: this.props.event_id  }
    },

    componentDidMount: function() {
   
    },

    componentWillReceiveProps: function(nextProps) {

      this.setState({
        current_selection: nextProps.current_selection,
        event_slug: nextProps.event_slug,
        category: nextProps.category,
        message: nextProps.messsage,
        event_id: this.props.event_id
      });
    },

    onUpdateMessage: function(_message) {
      this.setState({message: _message})
    },

    render: function() {


       //if current selection is null, empty state
        if(this.props.current_selection == null) {
            switch(this.state.category) {
              case 'ticketing':
                EditorPanelContent = <EditorPanelEmpty title={'Ticketing'} button_text={'Add ticket'} description={"Add new ticket. It sure is neat. PS, we've added a sample \"General Admssion\" ticket for you, to help you get started."} />;
              break;
              case 'coupons':
                EditorPanelContent = <EditorPanelEmpty title={'Coupon'} button_text={'Add coupon'} description={"Add a new coupon. Offer attendees a discount or promotion to encourage registration."} />;
              break;
              case 'questions':
                 EditorPanelContent = <EditorPanelEmpty title={'Questions'} button_text={'Add question'} description={"Add new question."} />
              break;
              default: 
                EditorPanelContent = <EditorPanelEmpty title={'Ticketing'} button_text={'Add ticket'} description={"Add new ticket. It sure is neat. PS, we've added a sample \"General Admssion\" ticket for you, to help you get started."} />
              break;
            }

        } else {
         EditorPanelContent = <EditorPanel current_selection={this.props.current_selection} event_slug={this.props.event_slug} event_id={this.props.event_id}  category={this.state.category} onUpdateMessage={this.onUpdateMessage} handleOnPanelUpdate={this.props.handleOnPanelUpdate} />
       }

        return (
           <div>
           <FormAlert message={this.state.message} />
            {EditorPanelContent}
       
            </div>
        )
   } 
});




       