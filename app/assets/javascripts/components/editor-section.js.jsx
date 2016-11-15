var EditorSection = React.createClass({
    getInitialState: function() {
        return { items: this.props.items, current_selection: this.props.current_selection, event_slug: this.props.event_slug, category: this.props.category, event_id: this.props.event_id}
    },
    getDefaultProps: function() {
        return { items: [], current_selection: ''}
    },

    componentDidMount: function() {
   
    },

    componentWillReceiveProps: function(nextProps) {
        this.setState({category: nextProps.category})
    },


    selectItem: function(item) {
        this.setState({current_selection: item});
    },
    onPanelUpdate: function() {

    },
    refreshNav: function() {

    },
    onAddedNewItem: function(item) {
        this.setState({current_selection: item})
    },


    onResetCurrentSelection: function(e) {
      //e.preventDefault();

      this.setState({
        current_selection: null
      });
    },
    render: function() {
        return (
           <div>

                <EditorAsideNav items={this.props.items} handleSelectItem={this.selectItem} current_selection={this.state.current_selection} handleRefreshNav={this.refreshNav} category={this.state.category} />
                <EditorPanelContainer current_selection={this.state.current_selection} ticket_types={this.props.ticket_types}  onUpdateMessage={this.onUpdateMessage} handleOnPanelUpdate={this.onPanelUpdate} event_slug={this.state.event_slug} event_id={this.state.event_id}  category={this.state.category} onAddedNewItem={this.onAddedNewItem} advance_tickets={this.props.advance_tickets}  handleSelectItem={this.selectItem} onResetCurrentSelection={this.onResetCurrentSelection} />
            </div>
        )
   } 
});

