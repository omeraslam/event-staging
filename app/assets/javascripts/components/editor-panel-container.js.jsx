var EditorPanelContainer = React.createClass({
    getInitialState: function() {
        return { current_selection: this.props.current_selection,
                 event_slug: this.props.event_slug,
                 category: this.props.category,
                 event_id: this.props.event_id  }
    },

    componentDidMount: function() {
   
    },

    componentWillReceiveProps: function(nextProps) {

      this.setState({
        current_selection: nextProps.current_selection,
        event_slug: nextProps.event_slug,
        category: nextProps.category,
        //message: nextProps.messsage,
        event_id: this.props.event_id,
        message: ''
      });
    },

    render: function() {
       //if current selection is null, empty state
       if(this.props.current_selection == null) {

            switch(this.state.category) {
              case 'ticket':
                EditorPanelContent = <EditorPanelEmpty event_date={this.props.event_date} title={'Ticketing'} button_text={'Add ticket'} description={"Add new ticket. It sure is neat. PS, we've added a sample \"General Admssion\" ticket for you, to help you get started."} onAddedNewItem={this.props.onAddedNewItem} category={this.state.category} handleSelectItem={this.props.handleSelectItem} />;
              break;
              case 'coupon':
                EditorPanelContent = <EditorPanelEmpty title={'Coupon'} button_text={'Add coupon'} description={"Add a new coupon. Offer attendees a discount or promotion to encourage registration."} onAddedNewItem={this.props.onAddedNewItem}  category={this.state.category} handleSelectItem={this.props.handleSelectItem} />;
              break;
              case 'question':
                 EditorPanelContent = <EditorPanelEmpty title={'Questions'} button_text={'Add question'} description={"Add new question."} onAddedNewItem={this.props.onAddedNewItem} category={this.state.category} handleSelectItem={this.props.handleSelectItem} />
              break;
              default: 
                EditorPanelContent = <EditorPanelEmpty event_date={this.props.event_date} title={'Ticketing'} button_text={'Add ticket'} description={"Add new ticket. It sure is neat. PS, we've added a sample \"General Admssion\" ticket for you, to help you get started."} onAddedNewItem={this.props.onAddedNewItem} category={this.state.category} handleSelectItem={this.props.handleSelectItem}/>
              break;
            }

        } else {
         EditorPanelContent = <EditorPanel current_selection={this.props.current_selection} ticket_types={this.props.ticket_types} event_slug={this.props.event_slug} event_id={this.props.event_id}  category={this.state.category} onUpdateMessage={this.props.onUpdateMessage} handleOnPanelUpdate={this.props.handleOnPanelUpdate} onAddedNewItem={this.props.onAddedNewItem} onRemovedNewItem={this.props.onRemovedNewItem} advance_tickets={this.props.advance_tickets} onResetCurrentSelection={this.props.onResetCurrentSelection} />
       }
        return (
           <div>
            {EditorPanelContent}
       
            </div>
        )
   } 
});




       