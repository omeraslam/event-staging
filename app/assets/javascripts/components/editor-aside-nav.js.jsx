var EditorAsideNav = React.createClass({
    getInitialState: function() {
        return { items: this.props.items, currentItem: null, handleSelectItem: this.props.handleSelectItem, category: this.props.category}
    },
    getDefaultProps: function() {
        return { items: []}
    },

    componentDidMount: function() {
   
    },

    selectItem: function(item) {
        this.setState({currentItem: item.id});
        this.props.handleSelectItem(item);
    },

    addNavItem: function() {
        switch(this.state.category) {
            case 'coupon':
            var itemObj = {"promo_code": "new coupon item", "discount": "0", "is_fixed": false, "is_active": false};
            break;
            case 'question':
            var itemObj = {"title": "new ticket item", "description": "1000 of 1000", "price": 0,"is_active": false, "ticket_limit": 1000, "buy_limit": 4, "stop_date": moment().format('YYYY-MM-DD')};
             
            break;
            case 'ticket':
             var itemObj = {"title": "new ticket item", "description": "1000 of 1000", "price": 0,"is_active": false, "ticket_limit": 1000, "buy_limit": 4, "stop_date": moment().format('YYYY-MM-DD')};
             default:
             break;
        }
        this.state.items.push(itemObj)
        this.setState({items: this.state.items})
        this.selectItem(itemObj);
    },

    refreshNav: function() {

    },

    render: function() {
        if(this.state.category == 'coupon' && this.state.items.length > 0) {
            var addButton = '';
        } else {
            var addButton = <a href="#" className="edit-aside-nav-add" onClick={this.addNavItem} ><h4>+ Add New {this.state.category} Type</h4> </a>
              
        }


        return (
            <ul className="editor-aside editor-aside-nav">
               
                {this.state.items.map(function(item, index){
                     return <EditorAsideNavItem currentItem={this.state.currentItem} key={index} item={item.item == undefined ? item: item.item} handleSelectEvent={this.selectItem} handleRefreshNav={this.refreshNav} />
                 }.bind(this))} 
            
                {addButton}
              
            </ul>
        )
   } 
});
