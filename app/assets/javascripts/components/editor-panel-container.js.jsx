var EditorPanelContainer = React.createClass({
    getInitialState: function() {
        return { current_selection: this.props.current_selection,
                 event_slug: this.props.event_slug,
                 category: this.props.category }
    },

    componentDidMount: function() {
   
    },

    componentWillReceiveProps: function(nextProps) {

      this.setState({
        current_selection: nextProps.current_selection,
        event_slug: nextProps.event_slug,
        category: nextProps.category
      });
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
         EditorPanelContent = <EditorPanel current_selection={this.props.current_selection} event_slug={this.props.event_slug} category={this.state.category} />
       }

        return (
           <div>
            {EditorPanelContent}
       
            </div>
        )
   } 
});




       