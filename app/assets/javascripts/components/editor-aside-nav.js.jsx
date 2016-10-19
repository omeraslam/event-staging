var EditorAsideNav = React.createClass({
    getInitialState: function() {
        return { items: this.props.items}
    },
    getDefaultProps: function() {
        return { items: []}
    },

    componentDidMount: function() {
   
    },

    selectItem: function(item) {
        this.props.handleSelectItem(item);
    },

    addNavItem: function() {
        var ticketObj = {"ticket_object": {"title": "new ticket item", "description": "1000 of 1000", "is_active": false, "ticket_limit": 1000, "buy_limit": 4, "stop_date": moment().format('YYYY-MM-DD')}};
        this.state.items.push(ticketObj)
        this.setState({items: this.state.items})
        this.props.handleSelectItem(ticketObj);
    },

    refreshNav: function() {

    },

    render: function() {


        return (
            <ul className="editor-aside editor-aside-nav">
               
                {this.state.items.map(function(item, index){
                     return <EditorAsideNavItem key={index} item={item.ticket_object} handleSelectEvent={this.selectItem} handleRefreshNav={this.refreshNav} />
                 }.bind(this))} 
   
                <a href="#" className="edit-aside-nav-add" onClick={this.addNavItem} ><h4>+ Add New Ticket Type</h4> </a>
              
            </ul>
        )
   } 
});
